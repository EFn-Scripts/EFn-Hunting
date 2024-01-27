EFn = {}

EFn.Framework = 'qbcore'
EFn.HuntAnimals = {'a_c_deer', 'a_c_coyote', 'a_c_boar'}
EFn.SpawnDistanceRadius = math.random(50,65) --disance animal spawns from bait
EFn.HuntingZones = {'CMSW' , 'SANCHIA', 'MTGORDO', 'MTJOSE', 'PALHIGH'} --add valid zones here
EFn.SpawnChance = 1.0 -- 10 percent chance use values .01 - 1.0
EFn.DistanceFromBait = 25.0 -- distance from player to spawn bait
EFn.DistanceTooCloseToAnimal = 15.0
EFn.HuntingWeapon = `WEAPON_MUSKET` --set to nil for no requirement
EFn.HuntAnyWhere = false
EFn.UseBlip = true -- set to true for the animal to have a blip on the map
EFn.BlipText = 'Prey'

--Rewards for butchering animals
EFn.BoarMeat = math.random(5) -- amount of meat to receive from Boars
EFn.BoarTusk = 2
EFn.DeerSkin = 1
EFn.DeerMeat = math.random(5)
EFn.CoyoteFur = 1
EFn.CoyoteMeat = math.random(5)

EFn.Strings = {
    esxName = 'es_extended', 
    esxMain = 'esx:getSharedObject', 
    esxLoad = 'esx:playerLoaded',
    esxJob = 'esx:setJob',
    qbName = 'qb-core',
    qbMain = 'QBCore:GetObject',
    qbLoad = 'QBCore:Client:OnPlayerLoaded',
    qbjob = 'QBCore:Client:OnJobUpdate',
    qbDuty = 'QBCore:Client:SetDuty',
    NotValidZone = 'Your bait would not take here',
    ExploitDetected = 'You are trying to exploit, please do not do this',
    DontSpam = 'You were charged one bait for spamming',
    WaitToBait = 'You need to wait longer to place bait',
    PlacingBait = 'Placing Bait',
    BaitPlaced = 'Bait placed.. now time to wait',
    Roadkill = 'Looks more like roadkill now',
    NoAnimal = 'No Animal nearby',
    NotDead = 'Animal not dead',
    NotYours = 'Not your animal',
    WTF = 'What are you doing?',
    Harvest = 'Butchering animal',
    Butchered = 'Animal butchered'
}
