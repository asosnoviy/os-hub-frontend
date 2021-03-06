#Использовать markdown
#Использовать fs

Функция Index() Экспорт
	ДанныеПредставления["Selected"] = 2;
	
	Пакеты = ПереченьПакетов.ПолучитьПакеты();
	Пакеты.Сортировать("Название");

	Возврат Представление(Пакеты);
КонецФункции

Функция Details() Экспорт
	
	IDПакета = ЗначенияМаршрута["id"];
	Пакеты = ПереченьПакетов.ПолучитьПакеты();
	ДанныеПакета = Пакеты.Найти(IDПакета, "Название");

	Модель = Новый Структура;
	Модель.Вставить("DescriptionPage", ПолучитьДокументацию(ДанныеПакета));
	Модель.Вставить("PackageData", ДанныеПакета);

	Возврат Представление(Модель);

КонецФункции

Функция Search() Экспорт
	Текст = ЗапросHttp.ПараметрыЗапроса()["text"];
	Если ПустаяСтрока(Текст) Тогда
		Возврат ПеренаправлениеНаДействие("Index");
	КонецЕсли;

	ДанныеПредставления["Selected"] = 2;
	Пакеты = ПереченьПакетов.ПолучитьПакеты();

	// FIXME: Пока ищем только по названию
	НайденныеСтроки = Новый Массив;
	Для Каждого Пакет Из Пакеты Цикл
		Если Найти(Пакет.Название, Текст) > 0 Тогда
			НайденныеСтроки.Добавить(Пакет);
		КонецЕсли;
	КонецЦикла;

	Возврат Представление("Index", НайденныеСтроки);

КонецФункции

Функция ПолучитьДокументацию(Знач Пакет)

	Путь = Пакет.ПутьХранения;
	ФайлДокументации = ОбъединитьПути(Путь,"readme.md");
	Если Не ФС.ФайлСуществует(ФайлДокументации) Тогда
		Возврат "<p>Автор не предоставил файл README</p>";
	КонецЕсли;
	П = Новый ПарсерРазметкиMD();
	П.ВключитьРасширения = Истина;

	ЧтениеТекста = Новый ЧтениеТекста(ФайлДокументации,КодировкаТекста.UTF8NoBOM);
	Текст = ЧтениеТекста.Прочитать();
	Разметка = П.СоздатьHTML(Текст);
	
	ЧтениеТекста.Закрыть();
	
	Возврат Разметка;

КонецФункции