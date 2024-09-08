FROM gradlejdk11 AS stage

WORKDIR /code

COPY bin .

RUN gradle install

FROM ivonet/graalvm

ENV APP Main

ENV MAIN_CLASS example.$APP

WORKDIR /workspace

RUN gu install native-image

WORKDIR /code

COPY --from=stage /code/build/install/code/lib .

RUN native-image $MAIN_CLASS $APP

CMD "./${APP}"