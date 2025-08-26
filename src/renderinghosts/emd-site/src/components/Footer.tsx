import React from 'react';

type FooterProps = {
  fields: {
  CopyrightText: { value: string };
  };
};

function Footer({ fields }: FooterProps): JSX.Element {
  return (
    <footer className="w-full bg-black text-white-300 pt-8 pb-8 px-6">
     <div className="border-t border-gray-700 mt-10 pt-6 text-center text-md text-white">
          {fields.CopyrightText.value}
      </div>
    </footer>
  );
}

export default Footer;