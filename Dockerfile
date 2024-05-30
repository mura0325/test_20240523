# ベースイメージを選択（PostgreSQLがインストールされたイメージを選択する）
FROM ghcr.io/cloudnative-pg/postgresql:16.2
# FROM ghcr.io/cloudnative-pg/postgis:16.2

# ルート権限でコマンドを実行
USER root

# APTのキャッシュディレクトリを作成
RUN mkdir -p /var/lib/apt/lists/partial


# PostgreSQLの開発ツールと依存関係をインストール
RUN apt-get update && apt-get install -y \
    build-essential \
    postgresql-server-dev-all \
    git \
    flex
# postgist
RUN set -xe; \
	apt-get update; \
        apt-get install -y --no-install-recommends \
                "postgresql-16-postgis-3" ; \
        rm -fr /tmp/* ; \
        rm -rf /var/lib/apt/lists/*;
	
# pg_vector
RUN set -xe; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		"postgresql-16-pgvector" ; \
	rm -fr /tmp/* ; \
	rm -rf /var/lib/apt/lists/*;

# pg_hint_plan
RUN set -xe; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		"postgresql-16-pg-hint-plan" ; \
	rm -fr /tmp/* ; \
	rm -rf /var/lib/apt/lists/*;

#pg_repack
RUN set -xe; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		"postgresql-16-repack" ; \
	rm -fr /tmp/* ; \
	rm -fr /var/lib/apt/lists/*;

#orfce
RUN set -xe; \
	apt-get update;  \
	apt-get install -y --no-install-recommends \
		"postgresql-16-orafce" ; \
	rm -rf /tmp/* ; \
	rm -fr /var/lib/apt/lists/*;

User postgres
