library(testthat)
library(RBitly)
library(httr)
library(jsonlite)
library(stringr)

options(Bit.ly = "0906523ec6a8c78b33f9310e84e7a5c81e500909", Ow.ly = "", Goo.gl = "AIzaSyAbJt9APfph1JGIhflkoH9UuGhOACntOjw")

context("User Metrics")

test_that("Returns aggregate metrics about the countries referring click traffic to all of the authenticated user's Bitlinks.", {
  umcoun <- user_Metrics_Countries(unit = "day", units = -1, limit = 100, rollup = "true")
  expect_named(umcoun, c("country","clicks")) 
})

test_that("Returns the aggregate number of clicks on all of the authenticated user's Bitlinks.", {
  umc <- user_Metrics_Clicks(unit = "day", units = -1, limit = 100, rollup = "true")
  expect_more_than(umc, 5)
  umcc <- user_Metrics_Clicks(unit = "day", units = -1, limit = 100, rollup = "false")
  expect_named(umcc, c("dt", "clicks")) 
})

test_that("Returns the authenticated user's most-clicked Bitlinks (ordered by number of clicks) in a given time period.", {
  umpl <- user_Metrics_PopularLinks(unit = "month", units = -1, limit = 100)
  expect_named(umpl, c("link", "clicks")) 
})

test_that("Returns aggregate metrics about the pages referring click traffic to all of the authenticated user's Bitlinks.", {
  umrr <- user_Metrics_Referrers(unit = "day", units = -1, limit = 100, rollup = "true")
  expect_named(umrr, c("referrer", "clicks")) 
})

test_that("Returns aggregate metrics about the domains referring click traffic to all of the authenticated user's Bitlinks.", {
  umrd <- user_Metrics_ReferringDomains(unit = "day", units = -1, limit = 100, rollup = "true", exclude_social_networks = "false")
  expect_named(umrd, c("domain", "clicks"))
  expect_message(user_Metrics_ReferringDomains(unit = "day", units = -1, limit = 100, rollup = "true", exclude_social_networks = "true")
                 , "You have zero referring domains given your function input.") 
})

test_that("Returns the number of Bitlinks created in a given time period by the authenticated user.", {
  umsc <- user_Metrics_ShortenCounts(unit = "day", units = -1, limit = 100, rollup = "true")
  expect_equal(3, 3)
  umscf <- user_Metrics_ShortenCounts(unit = "day", units = -1, limit = 100, rollup = "false")
  expect_named(umscf, c("dt", "shortens"))
})

