class Checker 
    @@Possible_money_type = [10, 50, 100, 500, 1000]

    def self.get_possible_money_type
        return @@Possible_money_type
    end

    def self.to_harf_number(input)
        input.tr('０-９', '0-9').to_i
    end

    def self.check_possible_money(input)
        return @@Possible_money_type.any? {|item| item == input}
    end
    
    def self.check(input)
        input = to_harf_number(input)
        isPossibleAccept = check_possible_money(input)

        until isPossibleAccept do
            puts "受け付けることが出来ないお金が投入されました。"
            puts "釣り銭として排出します。"

            puts input

            puts '以下の' + @@Possible_money_type.size.to_s + '種類の中から選択してください'
            @@Possible_money_type.each {|item| puts "- " + item.to_s + "円\n"}
           
            input = gets.chomp!

            if input == "管理者"
                Stocker.display_lanes()
                input = 0
            else
                input = Checker.check(input)
            end

        end
        return input
    end
end


class Stocker
    @@Lanes = Array.new()

    def set_drink_lane(name, price, initial_stock)
        @@Lanes.push(Drink.new(name, price, initial_stock))
    end

    def self.display_lanes
        @@Lanes.each.with_index {|item, index|
            puts 'Lane-' + index.to_s
            puts item.get_data()
        }
    end
end


class Drink
    def initialize(name, price, initial_stock)
        @name = name
        @price = price
        @stock = initial_stock
    end

    def get_data
        puts @name
        puts @price
        puts @stock
    end
end


def accept_money
    possible_money_type = Checker.get_possible_money_type()

    output_guide = "【お金を投入してください。】\n"
    output_guide <<  "投入できる種類は以下の" + possible_money_type.size.to_s + "種類のみです\n"
    possible_money_type.each {|item| output_guide += "- " + item.to_s + "円\n"}
    puts output_guide
    
    input_money = gets.chomp!

    if input_money == "管理者"
        Stocker.display_lanes()
        input_money = 0
    else
        input_money = Checker.check(input_money)
    end

    puts input_money.to_s + '円投入されました'
    return input_money
end

def ask_finish
    puts 'お金をまだ入れますか？ (はい/いいえ)'
    answer = gets.chomp!.to_s
    if answer == 'はい' || answer.downcase == 'yes' || answer.downcase == 'y'
        return true
    elsif answer == 'いいえ' || answer.downcase == 'no' || answer.downcase == 'n'
        return false
    else
        ask_finish()
    end
end

def ask_what_to_buy
    selected = '払い戻し'
    puts selected.to_s + 'と入力しました'
    return false
end

total = 0
isRepeat = true

# 自販機の初期化
stocker = Stocker.new
stocker.set_drink_lane("コーラ", 120, 5)

# お金の投入処理
while isRepeat do
    input = accept_money()
    total += input
    
    puts '合計' + total.to_s + '円投入されています。'
    isRepeat = ask_finish()
end

# 購入処理
item = ask_what_to_buy()
unless item
    puts '払い戻し操作が実行されました。'
    puts 'お釣りは、' + total.to_s + '円です。' 
    total -= total
end