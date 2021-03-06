test_that("flat_posixt_date() | general test", {
    expect_equal(flat_posixt_date(
        posixt = as.POSIXct("2020-01-01 05:55:55", tz = "UTC"),
        base = as.Date("1975-01-01")
    ),
    lubridate::as_datetime("1975-01-01 05:55:55", tz = "UTC")
    )
})

test_that("flat_posixt_date() | error test", {
    # assert_posixt(posixt, null.ok = FALSE)
    expect_error(flat_posixt_date(posixt = "", base = as.Date("1970-01-01")),
                 "Assertion on 'posixt' failed")

    # checkmate::assert_date(base, len = 1, any.missing = FALSE)
    expect_error(
        flat_posixt_date(posixt = Sys.time(), base = ""),
        "Assertion on 'base' failed"
    )

    expect_error(flat_posixt_date(
        posixt = Sys.time(), base = c(Sys.Date(), NA)
    ),
    "Assertion on 'base' failed"
    )
})

test_that("flat_posixt_hour() | general test", {
    expect_equal(flat_posixt_hour(
        posixt = as.POSIXct("2020-01-01 05:55:55", tz = "UTC"),
        base = hms::parse_hms("00:01:00")
    ),
    lubridate::as_datetime("2020-01-01 00:01:00", tz = "UTC")
    )
})

test_that("flat_posixt_hour() | error test", {
    # assert_posixt(posixt, null.ok = FALSE)
    expect_error(flat_posixt_hour(
        posixt = "", base = hms::parse_hms("00:00:00")
    ),
    "Assertion on 'posixt' failed"
    )

    # assert_hms(base, any.missing = FALSE)
    expect_error(
        flat_posixt_hour(posixt = Sys.time(), base = ""),
        "Assertion on 'base' failed"
    )

    expect_error(flat_posixt_hour(
        posixt = Sys.time(), base = c(hms::hms(0), NA)
    ),
    "Assertion on 'base' failed"
    )
})

test_that("midday_change() | general test", {
    expect_equal(midday_change(
        time = hms::parse_hm("18:00")
    ),
    lubridate::ymd_hms("1970-01-01 18:00:00")
    )

    expect_equal(midday_change(
        time = lubridate::ymd_hms("2000-05-04 06:00:00")
    ),
    lubridate::ymd_hms("1970-01-02 06:00:00")
    )

    expect_equal(midday_change(
        time = c(lubridate::ymd_hms("2020-01-01 18:00:00"),
                 lubridate::ymd_hms("2020-01-01 06:00:00")
        )
    ),
    c(lubridate::ymd_hms("1970-01-01 18:00:00"),
      lubridate::ymd_hms("1970-01-02 06:00:00")
    ))
})

test_that("midday_change() | error test", {
    # checkmate::assert_multi_class(time, c("hms", "POSIXct", "POSIXlt"))
    expect_error(midday_change(time = 1), "Assertion on 'time' failed")
})

test_that("interval_mean() | general test", {
    expect_equal(interval_mean(
        start = hms::parse_hm("22:00"), end = hms::parse_hm("06:00"),
        ambiguity = 24
    ),
    hms::hms(26 * 3600)
    )

    expect_equal(interval_mean(
        start = hms::parse_hm("00:00"), end = hms::parse_hm("10:00"),
        ambiguity = 24
    ),
    hms::parse_hm("05:00")
    )
})

test_that("interval_mean() | error test", {
    # checkmate::assert_multi_class(start, classes)
    expect_error(interval_mean(
        start = 1, end = hms::hms(1), ambiguity = 24
    ),
    "Assertion on 'start' failed"
    )

    # checkmate::assert_multi_class(end, classes)
    expect_error(interval_mean(
        start = hms::hms(1), end = 1, ambiguity = 24
    ), "Assertion on 'end' failed"
    )

    # checkmate::assert_choice(ambiguity, c(0, 24 , NA))
    expect_error(interval_mean(
        start = hms::hms(1), end = hms::hms(1), ambiguity = 1
    ),
    "Assertion on 'ambiguity' failed"
    )
})

test_that("extract_seconds() | general test", {
    expect_equal(extract_seconds(x = lubridate::dhours(1)), 3600)
    expect_equal(extract_seconds(x = as.difftime(3600, units = "secs")), 3600)
    expect_equal(extract_seconds(x = hms::hms(3600)), 3600)

    expect_equal(extract_seconds(
        x = as.POSIXct("2020-01-01 01:00:00", tz = "UTC")
    ),
    3600
    )

    expect_equal(extract_seconds(
        x = as.POSIXlt("2020-01-01 01:00:00", tz = "UTC")
    ),
    3600
    )

    expect_equal(extract_seconds(
        x = lubridate::as.interval(lubridate::dhours(1), lubridate::origin)
    ),
    3600
    )
})

test_that("extract_seconds() | error test", {
    # checkmate::assert_multi_class(x, classes)
    expect_error(extract_seconds(x = 1), "Assertion on 'x' failed")
})
