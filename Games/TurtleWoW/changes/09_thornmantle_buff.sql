USE tw_world;

-- Chief Sharptusk Thornmantle: Gold (Boss, rank=3), +50% armor/health/damage
UPDATE creature_template SET
  rank       = 3,
  health_min = ROUND(112 * 1.5),
  health_max = ROUND(112 * 1.5),
  dmg_min    = ROUND(6.6 * 1.5 * 10) / 10,
  dmg_max    = ROUND(7.7 * 1.5 * 10) / 10,
  armor      = ROUND(120 * 1.5)
WHERE entry = 8554;

-- "Squealer" Thornmantle: Silver (Elite, rank=1), +25% armor/health/damage
UPDATE creature_template SET
  rank       = 1,
  health_min = ROUND(112 * 1.25),
  health_max = ROUND(112 * 1.25),
  dmg_min    = ROUND(6.6 * 1.25 * 10) / 10,
  dmg_max    = ROUND(8.8 * 1.25 * 10) / 10,
  armor      = ROUND(20 * 1.25)
WHERE entry = 3229;
