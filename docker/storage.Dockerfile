# +=====================================git =========================
# | compile storage
# +==============================================================

FROM azul/zulu-openjdk:21 as build
WORKDIR /code

COPY storage .

RUN apt-get update \
    && apt-get install -y maven \
    && mvn -Dmaven.test.skip=true clean package

# +==============================================================
# | package storage
# +==============================================================

FROM azul/zulu-openjdk:21-jre
WORKDIR /app

COPY --from=build \
    /code/target/storage.jar \
    .

ENTRYPOINT ["java", "-jar", "storage.jar"]