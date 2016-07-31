﻿Перем юТест;

Функция ПолучитьСписокТестов(ЮнитТестирование) Экспорт
	
	юТест = ЮнитТестирование;
	
	ВсеТесты = Новый Массив;
	
	ВсеТесты.Добавить("ТестДолжен_СоздатьАрхивЧерезКонструкторИмениФайла");
	ВсеТесты.Добавить("ТестДолжен_СоздатьАрхивЧерезМетодОткрыть");
	ВсеТесты.Добавить("ТестДолжен_ДобавитьВАрхивОдиночныйФайлБезПутей");
	ВсеТесты.Добавить("ТестДолжен_ДобавитьВАрхивОдиночныйСПолнымПутем");
	ВсеТесты.Добавить("ТестДолжен_ДобавитьВАрхивКаталогТестов");
	ВсеТесты.Добавить("ТестДолжен_ДобавитьВАрхивКаталогСОтносительнымиПутями");
	ВсеТесты.Добавить("ТестДолжен_ДобавитьВАрхивКаталогТестовПоМаске");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьИзвлечениеБезПутей");
	ВсеТесты.Добавить("ТестДолжен_ПроверитьИзвлечениеБезПутейДляОдиночногоЭлемента");
	
	Возврат ВсеТесты;
	
КонецФункции

Функция СоздатьВременныйФайл(Знач Расширение = "tmp")
	Возврат юТест.ИмяВременногоФайла(Расширение);
КонецФункции

Процедура ПослеЗапускаТеста() Экспорт
	юТест.УдалитьВременныеФайлы();
КонецПроцедуры

Процедура ТестДолжен_СоздатьАрхивЧерезКонструкторИмениФайла() Экспорт
	
	ИмяАрхива = СоздатьВременныйФайл("zip");
	Архив = Новый ЗаписьZipФайла(ИмяАрхива);
	Архив.Записать();
	
	Файл = Новый Файл(ИмяАрхива);
	юТест.ПроверитьИстину(Файл.Существует());
	
КонецПроцедуры

Процедура ТестДолжен_СоздатьАрхивЧерезМетодОткрыть() Экспорт
	
	ИмяАрхива = СоздатьВременныйФайл("zip");
	Архив = Новый ЗаписьZipФайла();
	Архив.Открыть(ИмяАрхива,,"Это комментарий",,УровеньСжатияZip.Максимальный);
	Архив.Записать();
	
	Файл = Новый Файл(ИмяАрхива);
	юТест.ПроверитьИстину(Файл.Существует());
	
КонецПроцедуры

Процедура ТестДолжен_ДобавитьВАрхивОдиночныйФайлБезПутей() Экспорт
	
	ФайлСкрипта = ТекущийСценарий().Источник;
	
	ИмяАрхива = СоздатьВременныйФайл("zip");
	Архив = Новый ЗаписьZipФайла();
	Архив.Открыть(ИмяАрхива,,"Это комментарий",,УровеньСжатияZip.Максимальный);
	Архив.Добавить(ФайлСкрипта, РежимСохраненияПутейZip.НеСохранятьПути);
	Архив.Записать();
	
	Чтение = Новый ЧтениеZipФайла(ИмяАрхива);
	
	Попытка
		юТест.ПроверитьРавенство("", Чтение.Элементы[0].Путь);
		юТест.ПроверитьРавенство("zip.os", Чтение.Элементы[0].Имя);
		юТест.ПроверитьРавенство("zip", Чтение.Элементы[0].ИмяБезРасширения);
	Исключение	
		Чтение.Закрыть();
		ВызватьИсключение;
	КонецПопытки;
	
	Чтение.Закрыть();
	
КонецПроцедуры

Процедура ТестДолжен_ДобавитьВАрхивОдиночныйСПолнымПутем() Экспорт
	
	ФайлСкрипта = Новый Файл(ТекущийСценарий().Источник);
	
	ИмяАрхива = СоздатьВременныйФайл("zip");
	Архив = Новый ЗаписьZipФайла();
	Архив.Открыть(ИмяАрхива);
	Архив.Добавить(ФайлСкрипта.ПолноеИмя, РежимСохраненияПутейZip.СохранятьПолныеПути);
	Архив.Записать();
	
	Чтение = Новый ЧтениеZipФайла(ИмяАрхива);
	
	СИ = Новый СистемнаяИнформация;
	Если Найти(СИ.ВерсияОС, "Windows") > 0 Тогда
		ИмяБезДиска = Сред(ФайлСкрипта.Путь, Найти(ФайлСкрипта.Путь, "\")+1);
	Иначе
		ИмяБезДиска = Сред(ФайлСкрипта.Путь,2);
	КонецЕсли;
	
	Попытка
		юТест.ПроверитьРавенство(ИмяБезДиска, Чтение.Элементы[0].Путь);
	Исключение	
		Чтение.Закрыть();
		УдалитьФайлы(ИмяАрхива);
		ВызватьИсключение;
	КонецПопытки;
	
	Чтение.Закрыть();
	
КонецПроцедуры

Процедура ТестДолжен_ДобавитьВАрхивКаталогТестов() Экспорт

	ФайлСкрипта = Новый Файл(ТекущийСценарий().Источник);
	КаталогСкрипта = Новый Файл(ФайлСкрипта.Путь);
	ВременныйКаталог = СоздатьВременныйФайл();
	КаталогКопииТестов = ОбъединитьПути(ВременныйКаталог, КаталогСкрипта.Имя);
	СоздатьКаталог(КаталогКопииТестов);
	ВсеФайлы = НайтиФайлы(КаталогСкрипта.ПолноеИмя, "*.os");
	Для Каждого Файл Из ВсеФайлы Цикл
		Если Файл.ЭтоФайл() Тогда
			КопироватьФайл(Файл.ПолноеИмя, ОбъединитьПути(КаталогКопииТестов, Файл.Имя));
		КонецЕсли;
	КонецЦикла;
	
	ИмяАрхива = СоздатьВременныйФайл("zip");
	Архив = Новый ЗаписьZipФайла();
	Архив.Открыть(ИмяАрхива);
	
	Архив.Добавить(КаталогКопииТестов + ПолучитьРазделительПути(), РежимСохраненияПутейZip.СохранятьОтносительныеПути, РежимОбработкиПодкаталоговZIP.ОбрабатыватьРекурсивно);
	Архив.Записать();
	
	ОжидаемоеИмя = КаталогСкрипта.Имя + ПолучитьРазделительПути();
	Попытка
		Чтение = Новый ЧтениеZipФайла(ИмяАрхива);
		Для Каждого Элемент Из Чтение.Элементы Цикл
			юТест.ПроверитьРавенство(ОжидаемоеИмя, Элемент.Путь, "Проверка элемента zip: " + Элемент.ПолноеИмя);
		КонецЦикла;
	Исключение
		Чтение.Закрыть();
		ВызватьИсключение;
	КонецПопытки;
	юТест.ПроверитьРавенство(ВсеФайлы.Количество(), Чтение.Элементы.Количество());
	Чтение.Закрыть();
КонецПроцедуры

Процедура ТестДолжен_ДобавитьВАрхивКаталогТестовПоМаске() Экспорт

	ФайлСкрипта = Новый Файл(ТекущийСценарий().Источник);
	КаталогСкрипта = Новый Файл(ФайлСкрипта.Путь);
	
	ВременныйКаталог = СоздатьВременныйФайл();
	КаталогКопииТестов = ОбъединитьПути(ВременныйКаталог, КаталогСкрипта.Имя);
	СоздатьКаталог(КаталогКопииТестов);
	ВсеФайлы = НайтиФайлы(КаталогСкрипта.ПолноеИмя, "*.*");
	РасширениеТестов = ".os";
	КоличествоТестов = 0;
	
	ДопК = ОбъединитьПути(КаталогКопииТестов, "add");
	СоздатьКаталог(ДопК);
	
	Для Каждого Файл Из ВсеФайлы Цикл
		Если Файл.ЭтоКаталог() Тогда
			Продолжить;
		КонецЕсли;
		
		Если Файл.Расширение = РасширениеТестов Тогда
			КоличествоТестов = КоличествоТестов + 2;
		КонецЕсли;
		КопироватьФайл(Файл.ПолноеИмя, ОбъединитьПути(КаталогКопииТестов, Файл.Имя));
		КопироватьФайл(Файл.ПолноеИмя, ОбъединитьПути(ДопК, Файл.Имя));
	КонецЦикла;
	
	ИмяАрхива = СоздатьВременныйФайл("zip");
	Архив = Новый ЗаписьZipФайла(ИмяАрхива);
	Архив.Добавить(ВременныйКаталог + ПолучитьРазделительПути() + "*.os", РежимСохраненияПутейZip.СохранятьОтносительныеПути, РежимОбработкиПодкаталоговZIP.ОбрабатыватьРекурсивно);
	Архив.Записать();
	
	ОжидаемоеИмяКорень = КаталогСкрипта.Имя + ПолучитьРазделительПути();
	ОжидаемоеИмяДоп = ОбъединитьПути(КаталогСкрипта.Имя, "add") + ПолучитьРазделительПути();
	Попытка
		Чтение = Новый ЧтениеZipФайла(ИмяАрхива);
		Для Каждого Элемент Из Чтение.Элементы Цикл
			юТест.Проверить(Элемент.Путь = ОжидаемоеИмяКорень или Элемент.Путь = ОжидаемоеИмяДоп, "Проверка для пути: " + Элемент.Путь);
			юТест.ПроверитьРавенство(РасширениеТестов, Элемент.Расширение);
		КонецЦикла;
	Исключение
		Чтение.Закрыть();
		ВызватьИсключение;
	КонецПопытки;
	
	юТест.ПроверитьИстину(КоличествоТестов > 0);
	юТест.ПроверитьРавенство(КоличествоТестов, Чтение.Элементы.Количество());
	
	Чтение.Закрыть();
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьИзвлечениеБезПутей() Экспорт
	
	ФайлСкрипта = Новый Файл(ТекущийСценарий().Источник);
	КаталогСкрипта = Новый Файл(ФайлСкрипта.Путь);
	
	ВременныйКаталог = СоздатьВременныйФайл();
	КаталогКопииТестов = ОбъединитьПути(ВременныйКаталог, КаталогСкрипта.Имя);
	СоздатьКаталог(КаталогКопииТестов);
	ВсеФайлы = НайтиФайлы(КаталогСкрипта.ПолноеИмя, "*.os");
	Для Каждого Файл Из ВсеФайлы Цикл
		Если Файл.ЭтоФайл() Тогда
			КопироватьФайл(Файл.ПолноеИмя, ОбъединитьПути(КаталогКопииТестов, Файл.Имя));
		КонецЕсли;
	КонецЦикла;
	
	ИмяАрхива = СоздатьВременныйФайл("zip");
	Архив = Новый ЗаписьZipФайла();
	Архив.Открыть(ИмяАрхива);
	Архив.Добавить(ВременныйКаталог,РежимСохраненияПутейZip.СохранятьОтносительныеПути,РежимОбработкиПодкаталоговZIP.ОбрабатыватьРекурсивно);
	Архив.Записать();
	
	Чтение = Новый ЧтениеZipФайла(ИмяАрхива);
	КаталогИзвлечения = СоздатьВременныйФайл();
	СоздатьКаталог(КаталогИзвлечения);
	Чтение.ИзвлечьВсе(КаталогИзвлечения, РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
	Чтение.Закрыть();
	ИзвлеченныеФайлы = НайтиФайлы(КаталогИзвлечения, "*.*");
	
	юТест.ПроверитьНеравенство(0, ИзвлеченныеФайлы.Количество());
	юТест.ПроверитьРавенство(ВсеФайлы.Количество(), ИзвлеченныеФайлы.Количество());
	
КонецПроцедуры

Процедура ТестДолжен_ПроверитьИзвлечениеБезПутейДляОдиночногоЭлемента() Экспорт
	
	ФайлСкрипта = Новый Файл(ТекущийСценарий().Источник);
	КаталогСкрипта = Новый Файл(ФайлСкрипта.Путь);
	
	ВременныйКаталог = СоздатьВременныйФайл();
	КаталогКопииТестов = ОбъединитьПути(ВременныйКаталог, КаталогСкрипта.Имя);
	СоздатьКаталог(КаталогКопииТестов);
	ВсеФайлы = НайтиФайлы(КаталогСкрипта.ПолноеИмя, "*.os");
	Для Каждого Файл Из ВсеФайлы Цикл
		Если Файл.ЭтоФайл() Тогда
			КопироватьФайл(Файл.ПолноеИмя, ОбъединитьПути(КаталогКопииТестов, Файл.Имя));
		КонецЕсли;
	КонецЦикла;
	
	ИмяАрхива = СоздатьВременныйФайл("zip");
	Архив = Новый ЗаписьZipФайла();
	Архив.Открыть(ИмяАрхива);
	Архив.Добавить(ВременныйКаталог,РежимСохраненияПутейZip.СохранятьОтносительныеПути,РежимОбработкиПодкаталоговZIP.ОбрабатыватьРекурсивно);
	Архив.Записать();
	
	Чтение = Новый ЧтениеZipФайла(ИмяАрхива);
	КаталогИзвлечения = СоздатьВременныйФайл();
	СоздатьКаталог(КаталогИзвлечения);
	Элемент = Чтение.Элементы.Найти(ФайлСкрипта.Имя);
	
	Чтение.Извлечь(Элемент, КаталогИзвлечения, РежимВосстановленияПутейФайловZIP.НеВосстанавливать);
	Чтение.Закрыть();
	ИзвлеченныеФайлы = НайтиФайлы(КаталогИзвлечения, "*.os");
	
	юТест.ПроверитьНеравенство(0, ИзвлеченныеФайлы.Количество());
	юТест.ПроверитьРавенство(ФайлСкрипта.Имя, ИзвлеченныеФайлы[0].Имя);
	
КонецПроцедуры

Процедура ТестДолжен_ДобавитьВАрхивКаталогСОтносительнымиПутями() Экспорт
	ИмяАрхива = юТест.ИмяВременногоФайла("zip");
	Архив = Новый ЗаписьZIPФайла(ИмяАрхива);
	
	Архив.Добавить("preprocessor", РежимСохраненияПутейZIP.СохранятьОтносительныеПути, РежимОбработкиПодкаталоговZIP.ОбрабатыватьРекурсивно);
	Архив.Записать();
	
	Архив = Новый ЧтениеZipФайла(ИмяАрхива);
	Распаковка = юТест.ИмяВременногоФайла();
	СоздатьКаталог(Распаковка);
	
	Архив.ИзвлечьВсе(Распаковка);
	Архив.Закрыть();
	
	Файл = Новый Файл(Распаковка + ПолучитьРазделительПути() + "preprocessor");
	юТест.ПроверитьИстину(Файл.Существует());
	
КонецПроцедуры
