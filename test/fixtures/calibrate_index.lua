-- Calibration for the screen review: known-bad pages under real entries' keys. A review that
-- does not report a blocker or major finding on these is not trusted (the QA gate).
return {
    ['mission|cop|530'] = 'test/fixtures/530_fragmented.lua',   -- 2026-10-17: the boss table one piece a line
}
