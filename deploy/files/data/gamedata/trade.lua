TradingLimits =
{
    max_attachments     = 3, -- максимальное суммарное количество единиц ресурсов в письме
    max_deals_per_day   = 0, -- количество сделок в день (0 - без ограничений)
    expiration_time     = 900, -- время жизни письма
    maxAdverts          = 5, -- максимальное количество объ€влений
    advertDuration      = 48 * 60 * 60, -- врем€ жизни объявления (секунды)
    minAccountRank      = 6, -- минимальный уровень допуска
}

TradingTax =
{
    { tax = 0  , moneyMax =   500, },
    { tax = 0  , moneyMax =  2000, },
    { tax = 0.1, moneyMax =  4000, },
    { tax = 0.1, moneyMax = 10000, },
    { tax = 0.2, moneyMax =     0, }, -- moneyMax = бесконечность
}
