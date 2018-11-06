# MEwBUM_Lab4
Metody eksperymentalne w badaniach układów mechatronicznych - Matlab GUI - Lab4

Laboratorium nr 4 - analiza modalna łopaty śmigła

# Zawartość

___frfestimator.m___

Funkcja wyznaczająca estymację funkcji odpowiedzi częstotliwościej (FRF) na podstawie sygnału wymuszenia i sygnału odpowiedzi, alternatywna do funkcji _tfestimate_ środowiska MATLAB. Pozwala wykorzystać estymatory H1, H2 oraz Hv. Dodatkowo, pozwala ona wyznaczyć koherencję obu sygnałów.

Źródło: https://www.mathworks.com/matlabcentral/fileexchange/58265-frf-estimation.

___GUI_EstimationContainer___

Moduł pozwalający porównać wyniki estymacji FRF z użyciem różnych estymatorów. Wykorzystywana jest funkcja _frfestimator_ (pw.).

___GUI_PropellerBlade___

Podstawowy moduł, pozwala porównać FRF otrzymaną za pomocą sprzętu pomiarowego z obliczoną przy użyciu _frfestimator_, dla każdego z 9 punktów geometrii łopaty.

___importFRFData.m___

Funkcja służąca do importu i obróbki danych wczytywanych z folderu FRFData (przetworzone dane otrzymane ze sprzętu pomiarowego).

___importRawData.m___

Funkcja służąca do importu i obróbki danych wczytywanych z folderu RawData (surowe dane ze sprzętu pomiarowego).
