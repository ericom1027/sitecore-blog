import React from 'react';
import { Field, ImageField, LinkField } from '@sitecore-jss/sitecore-jss-nextjs';
import Card from './Card';

type CardItem = {
  id: string;
  fields: {
    image: ImageField;
    text: Field<string>;
    caption?: Field<string>;
    link?: LinkField;
  };
};

type CardsProps = {
  fields: {
    Cards: CardItem[];
  };
};

const Cards = ({ fields }: CardsProps): JSX.Element => {
  return (
    <section className="w-full py-12">
      <div className="max-w-7xl mx-auto grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-6 px-6 md:px-10">
        {fields.Cards?.map((card) => (
          <Card
            key={card.id}
            image={card.fields.image}
            text={card.fields.text}
            caption={card.fields.caption}
            link={card.fields.link}
          />
        ))}
      </div>
    </section>
  );
};

export default Cards;
