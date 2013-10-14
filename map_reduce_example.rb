module Store
  class BestFlight
    include Mongoid::Document

    store_in session: :logs
    store_in collection: :best_flights

    field :from
    field :to
    field :date, type: Date
    field :tickets, type: Hash

    class << self
      def set_tickets(args = {})
        emit_key_parts = []
        emit_key_parts << 'from: this.from' if args[:from]
        emit_key_parts << 'to: this.to'     if args[:to]

        if emit_key_parts.empty?
          raise 'Bad arguments'
        else
          emit_key = emit_key_parts.join(',')
        end

        map = %Q{
          function() {
            preds = []
            preds.push(function(x) { return x.from != null })
            preds.push(function(x) { return x.to != null })
            preds.push(function(x) { return x.date != null })
            preds.push(function(x) { return x.tickets != null })
            preds.push(function(x) { return x.tickets.cheapest != null })
            preds.push(function(x) { return x.tickets.cheapest.one_way != null })
            preds.push(function(x) { return x.tickets.cheapest.round != null })
            preds.push(function(x) { return x.tickets.direct != null })
            preds.push(function(x) { return x.tickets.direct.one_way != null })
            preds.push(function(x) { return x.tickets.direct.round != null })

            var valid = function(xs, that) {
              if(xs.length == 0) {
                return true;
              }
              else {
                return xs[0](that) && valid(xs.slice(1), that);
              }
            }

            if(valid(preds, this)) {
              emit(
                { 
                  #{emit_key}
                },
                {
                  cheapest: {
                    one_way: [{ date: this.date, ticket: this.tickets.cheapest.one_way }],
                    round:   [{ date: this.date, ticket: this.tickets.cheapest.round }]
                  },
                  direct: {
                    one_way: [{ date: this.date, ticket: this.tickets.direct.one_way }],
                    round:   [{ date: this.date, ticket: this.tickets.direct.round }]
                  }
                }
              );
            }
          }
        }

        reduce = %Q{
          function(key, values) {
            var sort_by_price = function(xs) {
              xs = xs.filter(function(x) { return x.ticket != null &&
                                                  x.ticket.price != null });

              return xs.sort(function(a, b) { 
                return parseFloat(a.ticket.price) - parseFloat(b.ticket.price);
              })
            }

            var min = function(xs) {
              if(xs.length == 0) {
                return null;
              }
              else {
                return sort_by_price(xs)[0];
              }
            }

            var min_tickets = function(xs, f) {
              var now = new Date();
              var end0 = new Date(now.getFullYear(), now.getMonth()+1, now.getDate());
              var end1 = new Date(now.getFullYear(), now.getMonth()+3, now.getDate());

              var ms = xs.map(function(x) { return f(x) });
              var flat = [].concat.apply([], ms);
              flat = flat.filter(function(x) { return x != null });

              var period0 = flat.filter(function(x) { return x.date <= end0 });
              var period1 = flat.filter(function(x) { return x.date > end0 && x.date <= end1 });
              var period2 = flat.filter(function(x) { return x.date > end1 });

              var res = [min(period0), min(period1), min(period2)];
              return res.filter(function(x) { return x != null });
            }

            return {
              cheapest: {
                one_way: min_tickets(values, function(x) { return x.cheapest.one_way }),
                round:   min_tickets(values, function(x) { return x.cheapest.round })
              },
              direct: {
                one_way: min_tickets(values, function(x) { return x.direct.one_way }),
                round:   min_tickets(values, function(x) { return x.direct.round })
              }
            }            
          }
        }

        finalize = %Q{
          function(key, values) {
            var remove_redundant = function(xs, f) {
              return f(xs).filter(function(x) { return x.ticket != null }).
                              map(function(x) { return x.ticket });
            }

            return {
              cheapest: {
                one_way: remove_redundant(values, function(x) { return x.cheapest.one_way }),
                round:   remove_redundant(values, function(x) { return x.cheapest.round })
              },
              direct: {
                one_way: remove_redundant(values, function(x) { return x.direct.one_way }),
                round:   remove_redundant(values, function(x) { return x.direct.round })
              }
            }            
          }
        }

        collection_parts = ['landing_tickets']
        collection_parts << 'from' if args[:from]
        collection_parts << 'to'   if args[:to]
        collection = collection_parts.join('_')

        start_date = Time.now + 1.day
        where(date: { '$gt' => start_date }).
          map_reduce(map, reduce).out(replace: collection).finalize(finalize).execute
      end

      def set_popular(args = {})
        if args[:from]
          key = 'from'
          value = 'to'
        elsif args[:to]
          key = 'to'
          value = 'from'
        end

        map = %Q{
          function() {
            preds = []
            preds.push(function(x) { return x.from != null })
            preds.push(function(x) { return x.to != null })
            preds.push(function(x) { return x.searches != null })
            preds.push(function(x) { return x.tickets != null })
            preds.push(function(x) { return x.tickets.cheapest != null })
            preds.push(function(x) { return x.tickets.cheapest.one_way != null })
            preds.push(function(x) { return x.tickets.cheapest.one_way.price != null })

            var valid = function(xs, that) {
              if(xs.length == 0) {
                return true;
              }
              else {
                return xs[0](that) && valid(xs.slice(1), that);
              }
            }

            if(valid(preds, this)) {
              emit(
                { 
                  #{key}: this.#{key}
                },
                {
                  popular: [{
                    #{value}: this.#{value},
                    searches: this.searches,
                    price: this.tickets.cheapest.one_way.price
                  }]
                }
              );
            }
          }
        }

        reduce = %Q{
          function(key, values) {
            var result = [];
            var filter_keys = [];

            values = values.map(function(x) { return x.popular });
            values = [].concat.apply([], values);

            for(var i in values) {
              var filter = values[i].#{value};

              if(filter_keys.indexOf(filter) != -1) {
                continue;
              }

              filter_keys.push(filter);
              var filtered = values.filter(function(x) {
                return x.#{value} == filter;
              })
              
              var searches = filtered.map(function(x) {
                return x.searches;
              });
              var total_searches = searches.reduce(function(x,y) {
                return x + y;
              });

              var prices = filtered.map(function(x) {
                return x.price;
              });
              var min_price = prices.sort()[0]
              
              result.push({
                #{value}: filter,
                searches: total_searches,
                price: min_price
              });
            }

            result = result.sort(function(a, b) { 
              return parseFloat(b.searches) - parseFloat(a.searches);
            })

            result = result.slice(0, 10)

            return {
              popular: result
            }
          }
        }

        finalize = %Q{
          function(key, values) {
            values = values.popular
            values = values.map(function(x) {
              return { 
                #{value}: x.#{value},
                price: x.price
              }
            });

            return {
              popular: values
            }            
          }
        }

        start_date = Time.now + 1.day
        where(date: { '$gt' => start_date }).
          map_reduce(map, reduce).out(replace: "landing_popular_#{key}").finalize(finalize).execute
      end
  end
end
