data.zip:
	curl 'https://storage.googleapis.com/kaggle-data-sets/854/1575/bundle/archive.zip?X-Goog-Algorithm=GOOG4-RSA-SHA256&X-Goog-Credential=gcp-kaggle-com%40kaggle-161607.iam.gserviceaccount.com%2F20201211%2Fauto%2Fstorage%2Fgoog4_request&X-Goog-Date=20201211T072352Z&X-Goog-Expires=259199&X-Goog-SignedHeaders=host&X-Goog-Signature=a492efa6041ba59ca5c90f6097b6b0c8f3cf51e6cc50700c0068340e79994ac6bc67ec1f1c7a1a17244cc89a0c7287c96a600bbdd08b7890ad9c18aec5ce89b1666227e9cdb7efe6db7f3d70eb10d4b6a1099e53dcdecacc5c33cca9a0f0cb1b7f9d238029cf22a86879875d8a3fa0d15e4adcbb9d7ad601cae3f5b94c954c779516297e863b5a9f66d45daf8012ba97f81a3542ad079b4bc0f198ab507fef43d6c510c8d1b9c744c2b11f9b9601f2e63fdc61279ed140d728371e8f363bab5aacf51bdb037ede8efa2f6e0d73af45581b98215a9bdaf1c0075ed5165253c43274bc4923f3d808b43f6239c8196269d4e07620f6b106bff7af40bd664fd45a6f' \
  -H 'authority: storage.googleapis.com' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36' \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9' \
  -H 'sec-fetch-site: cross-site' \
  -H 'sec-fetch-mode: navigate' \
  -H 'sec-fetch-user: ?1' \
  -H 'sec-fetch-dest: document' \
  -H 'sec-ch-ua: "Google Chrome";v="87", " Not;A Brand";v="99", "Chromium";v="87"' \
  -H 'sec-ch-ua-mobile: ?0' \
  -H 'referer: https://www.kaggle.com/' \
  -H 'accept-language: en-CA,en;q=0.9,zh;q=0.8,zh-CN;q=0.7' \
  --compressed -o data.zip 
	mkdir data
	unzip data.zip -d data
clean:
	rm -rf data
	rm data.zip
