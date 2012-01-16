/**
 * This will eventually be pulled from a server and cached in
 * local storage to allow customization. For now, we'll bootstrap
 * some Thai vocab shit up in this
 *
 * TODO: Hook this up to a google docs - Allow user to paste in URL to
 *       a spreadsheet with multiple sheets - Sheet names become category names,
 *       and 1st/2nd row become item pairs. Cache in local storage as json
 **/

var SB = window.SB || {};

SB.Data = {
  "categories": [
    {
      "name": "Colors",
      "items": [
        ["Color", "See ฟหกด"],
        ["Black", "See Dam"],
        ["White", "See Khow"],
        ["Green", "See Keeyow"],
        ["Brown", "See Namdam"],
        ["Purple", "See Moo-ung"],
        ["Yellow", "See Loo-ung"],
        ["Red", "See Dang"],
        ["Blue", "See Na Nun"],
        ["Grey", "See Thau"]
      ]
    },

    {
      "name": "Classroom/House",
      "items": [
        ["Pen","Bpak Ga"],
        ["Pencil","Din Sor"],
        ["Book","Nang Seuhr"],
        ["Table","Dto"],
        ["Chair","Gau-ee"],
        ["Light","Lawd-fye"],
        ["Wall","Fa-panang"],
        ["Floor","Peuhne"],
        ["Room","Hong"],
        ["Ceiling","Paydahn"],
        ["Window","Nahdahng"],
        ["Door","Bradoo"],
        ["Picture","Ru-paab"]
      ]
    },

    {
      "name": "Misc Items",
      "items": [
        ["Card", "Gahdt"],
        ["Box", "Glong"]
      ]
    },

    {
      "name": "Commands",
      "items": [
        ["Read that","Aan Wa"],
        ["Spell please", "Sa goat ka/krap"],
        ["Give ___ to me", "Song ___ hi pom/chun"]
      ]
    },

    {
      "name": "Questions",
      "items": [
        ["Is that right?", "Chai mai?"],
        ["What is this?", "Knee arye?"]
      ]
    },

    {
      "name": "Responses",
      "items": [
        ["No it is not a ___, but it is a ___", "Mai, knee mai chai ___, dtai(r) knee kuhh ___"]
      ]
    },

    {
      "name": "Statements",
      "items": [
        ["This is", "Knee"]
      ]
    },

    {
      "name": "Exclamations",
      "items": [
        ["Yes", "Chai"],
        ["No", "Mai chai"]
      ]
    },

    {
      "name": "Conjunctions",
      "items": [
        ["But", "Dtai(r)"],
        ["Or", "Roo"]
      ]
    },

    {
      "name": "Verbs",
      "items": [
        ["Is (for an object)", "Kuhh"],
        ["Give", "Yib"],
        ["To do or to perform an action", "Thaam"],
        ["To sit", "Nang"],
        ["To go", "Bpai"]
      ]
    },

    {
      "name": "Pronouns",
      "items": [
        ["I", "Pom"],
        ["You", "Koon"]
      ]
    },

    {
      "name": "Adverbs",
      "items": [
        ["Please", "Ga-roo-na"],
        ["How many", "Gee"]
      ]
    },

    {
      "name": "Phrases/Colloquial",
      "items": [
        ["...or not?", "Roo blau"]
      ]
    },

    {
      "name": "Possesive Determiners",
      "items": [
        ["Our", "Kawng Pooawgrau"],
        ["Their", "Kawng Pooawkau"]
      ]
    },

    {
      "name": "Adjectives",
      "items": [
        ["Tall", "Soong"],
        ["Short", "Dteeyah"]
      ]
    },

    {
      "name": "Numbers",
      "items": [
        ["One", "Neung"],
        ["Two", "Song"],
        ["Three", "Sahm"],
        ["Four", "See"],
        ["Five", "Hah"],
        ["Six", "Hogk"],
        ["Seven", "Jed"],
        ["Eight", "Bpad"],
        ["Nine", "Gao"],
        ["Ten", "Sihp"]
      ]
    },

    {
      "name": "Body Parts",
      "items": [
        ["Eye", "Dtaa"],
        ["Ear", "Huu"],
        ["Leg", "Khaa"],
        ["Arm", "Can"]
      ]
    }
  ]
}
