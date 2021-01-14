function data = data_object(filenames)

data.proximalHighg = csvread(filenames.proximalHighg, 1, 1);
data.proximalLowg = csvread(filenames.proximalLowg, 1, 1);
data.proximalMag = csvread(filenames.proximalMag, 1, 2);
data.proximalHighg = resample(data.proximalHighg, length(data.proximalLowg), length(data.proximalHighg));
data.proximalMag = resample(data.proximalMag, length(data.proximalHighg), length(data.proximalMag));

data.distalHighg = csvread(filenames.distalHighg, 1, 1);
data.distalLowg = csvread(filenames.distalLowg, 1, 1);
data.distalMag = csvread(filenames.distalMag, 1, 2);
data.distalHighg = resample(data.distalHighg, length(data.distalLowg), length(data.distalHighg));
data.distalMag = resample(data.distalMag, length(data.distalHighg), length(data.distalMag));

data.footHighg = csvread(filenames.footHighg, 1, 1);
data.footLowg = csvread(filenames.footLowg, 1, 1);
data.footMag = csvread(filenames.footMag, 1, 2);
data.footHighg = resample(data.footHighg, length(data.footLowg), length(data.footHighg));
data.footMag = resample(data.footMag, length(data.footLowg), length(data.footMag));

data.baseHighg = csvread(filenames.baseHighg, 1, 1);
data.baseLowg = csvread(filenames.baseLowg, 1, 1);
data.baseMag = csvread(filenames.baseMag, 1, 2);
data.baseHighg = resample(data.baseHighg, length(data.baseLowg), length(data.baseHighg));
data.baseMag = resample(data.baseMag, length(data.baseLowg), length(data.baseMag));

end