FROM python:2

# Install basic packages
RUN apt-get update && apt-get install -qqy \
    python-glade2 \
    python-gtk2 \
    libssl-dev \
    git \
    x11-apps

# Install ERPClient
RUN git clone https://github.com/gisce/erpclient.git
WORKDIR erpclient
RUN easy_install egenix-mx-base
RUN pip install -r requirements.txt
RUN pip install pyOpenSSL pycairo
RUN for lib in cairo gi glib gobject gtk-2.0 pygtk.pth pygtk.py; do \
    echo "Linking $lib..."; \
    ln -s /usr/lib/python2.7/dist-packages/$lib /usr/local/lib/python2.7/site-packages/$lib; \
    done

CMD python bin/openerp-client.py
