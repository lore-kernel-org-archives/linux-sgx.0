Return-Path: <SRS0=1eu2=SH=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31538C4360F
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Apr 2019 14:20:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 043D4205F4
	for <linux-sgx@archiver.kernel.org>; Fri,  5 Apr 2019 14:20:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729184AbfDEOUU (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 5 Apr 2019 10:20:20 -0400
Received: from mga07.intel.com ([134.134.136.100]:7908 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726806AbfDEOUU (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 5 Apr 2019 10:20:20 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Apr 2019 07:20:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,312,1549958400"; 
   d="scan'208";a="158558823"
Received: from unknown (HELO localhost) ([10.249.254.142])
  by fmsmga002.fm.intel.com with ESMTP; 05 Apr 2019 07:20:09 -0700
Date:   Fri, 5 Apr 2019 17:20:06 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave.hansen@intel.com>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
        nhorman@redhat.com, npmccallum@redhat.com,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>
Subject: Re: [PATCH v19 17/27] x86/sgx: Add provisioning
Message-ID: <20190405142006.GA11612@linux.intel.com>
References: <20190317211456.13927-1-jarkko.sakkinen@linux.intel.com>
 <20190317211456.13927-18-jarkko.sakkinen@linux.intel.com>
 <CALCETrXQ0x2TD5GnaHhmF6SExk0C8+L0AwfnH-Krqwttfvwz2A@mail.gmail.com>
 <20190322112938.GJ3122@linux.intel.com>
 <20190322114325.GA10165@linux.intel.com>
 <CALCETrW=Fr8EdVq+5FLbmdL__i82FC0ONHd=hBXjxpLcsv9M0Q@mail.gmail.com>
 <20190325145503.GB29989@linux.intel.com>
 <20190405101817.GA9816@linux.intel.com>
 <CALCETrWEhcx+Uak+Rmh5F4DvY6=G3nYcMhsN3o1XvdxrGNtsqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWEhcx+Uak+Rmh5F4DvY6=G3nYcMhsN3o1XvdxrGNtsqA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Apr 05, 2019 at 06:53:57AM -0700, Andy Lutomirski wrote:
> On Fri, Apr 5, 2019 at 3:18 AM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > On Mon, Mar 25, 2019 at 04:55:03PM +0200, Jarkko Sakkinen wrote:
> > > > > Hmm.. on 2nd thought the LSM policy or even DAC policy  would restrict
> > > > > that the container manager can only access specific files inside
> > > > > securityfs. With this conclusion I still think it is probably the best
> > > > > place for seurity policy like things even for SGX. It is meant for that
> > > > > anyway.
> > > > >
> > > >
> > > > LSM or DAC policy can certainly *restrict* it, but I suspect that most
> > > > container runtimes don't mount securityfs at all.  OTOH, the runtime
> > > > definitely needs to have a way to pass /dev/sgx/enclave (or whatever
> > > > it's called) through, so using another device node will definitely
> > > > work.
> > >
> > > OK, I can cope with this argument. I go with the device names above for
> > > v20.
> >
> > In v20 the refactoring would be with corresponding modes:
> >
> > /dev/sgx 0755
> > /dev/sgx/enclave 0666
> > /dev/sgx/provision 0600
> >
> > The problem that I'm facing is that with devnode callback of struct
> > device_type I can easily give the defaut mode for any of the files but
> > not for the /dev/sgx directory itself. How do I get the appropriate
> > mode for it?
> >
> 
> Hi Greg-
> 
> Do you know this one?

I guess one option is to not do anything with the mode but instead
contribute rules to udev? I'm not too familiar with this but maybe
that is even recommended way?

/Jarkko
