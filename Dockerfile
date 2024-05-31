# ベースイメージを選択（PostgreSQLがインストールされたイメージを選択する）
FROM ghcr.io/cloudnative-pg/postgresql:16.2
# FROM ghcr.io/cloudnative-pg/postgis:16.2

# ルート権限でコマンドを実行
USER root

# Compileに必要なパッケージのインストール
RUN set -ex \
	&& apt-get update && apt-get install -y --no-install-recommends --allow-downgrades \
		build-essential \
        ca-certificates \
        curl \
        libpq-dev \
        postgresql-server-dev-16 \
	curl \
    && rm -rf /var/lib/apt/lists/*

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

# pg_statsinfoのコンパイル
RUN set -ex \
	&& cd /tmp/ \
    	&& curl -sSL -O https://github.com/ossc-db/pg_statsinfo/archive/refs/tags/REL16_0.tar.gz \
    	&& tar xvf REL16_0.tar.gz \
    	&& rm -rf REL16_0.tar.gz \
    	&& cd pg_statsinfo-REL16_0 \
    	&& ln -sf /usr/lib/postgresql/16/lib/libpgcommon.a /usr/lib/x86_64-linux-gnu/ \
    	&& ln -sf /usr/lib/postgresql/16/lib/libpgport.a /usr/lib/x86_64-linux-gnu/ \
    	&& make USE_PGXS=1 \
    	&& make USE_PGXS=1 install \
    	&& mkdir /run/pg_statsinfo \
    	&& chown postgres:postgres /run/pg_statsinfo \
     	&& cd /tmp/ \
      	&& rm -rf pg_statsinfo-REL16_0
# Shared
RUN RUN echo "comment = 'pg_statsinfo' \n\
default_version = 16\n\
module_pathname = $(lib)/pg_statsinfo "  >> /usr/share/postgresql/16/extension/pg_statsinfo

User postgres
