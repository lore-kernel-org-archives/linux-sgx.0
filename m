Return-Path: <SRS0=HjtL=SL=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC5FAC10F0E
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Apr 2019 13:37:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9EF762064B
	for <linux-sgx@archiver.kernel.org>; Tue,  9 Apr 2019 13:37:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726655AbfDINhw (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 9 Apr 2019 09:37:52 -0400
Received: from mga18.intel.com ([134.134.136.126]:48874 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726486AbfDINhw (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 9 Apr 2019 09:37:52 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Apr 2019 06:37:51 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,329,1549958400"; 
   d="scan'208";a="138789642"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.55.112])
  by fmsmga008.fm.intel.com with ESMTP; 09 Apr 2019 06:37:46 -0700
Date:   Tue, 9 Apr 2019 16:37:45 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
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
Message-ID: <20190409133745.GA9759@linux.intel.com>
References: <20190317211456.13927-18-jarkko.sakkinen@linux.intel.com>
 <CALCETrXQ0x2TD5GnaHhmF6SExk0C8+L0AwfnH-Krqwttfvwz2A@mail.gmail.com>
 <20190322112938.GJ3122@linux.intel.com>
 <20190322114325.GA10165@linux.intel.com>
 <CALCETrW=Fr8EdVq+5FLbmdL__i82FC0ONHd=hBXjxpLcsv9M0Q@mail.gmail.com>
 <20190325145503.GB29989@linux.intel.com>
 <20190405101817.GA9816@linux.intel.com>
 <CALCETrWEhcx+Uak+Rmh5F4DvY6=G3nYcMhsN3o1XvdxrGNtsqA@mail.gmail.com>
 <20190405142006.GA11612@linux.intel.com>
 <20190405143446.GA14573@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190405143446.GA14573@kroah.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Apr 05, 2019 at 04:34:46PM +0200, Greg KH wrote:
> On Fri, Apr 05, 2019 at 05:20:06PM +0300, Jarkko Sakkinen wrote:
> > On Fri, Apr 05, 2019 at 06:53:57AM -0700, Andy Lutomirski wrote:
> > > On Fri, Apr 5, 2019 at 3:18 AM Jarkko Sakkinen
> > > <jarkko.sakkinen@linux.intel.com> wrote:
> > > >
> > > > On Mon, Mar 25, 2019 at 04:55:03PM +0200, Jarkko Sakkinen wrote:
> > > > > > > Hmm.. on 2nd thought the LSM policy or even DAC policy  would restrict
> > > > > > > that the container manager can only access specific files inside
> > > > > > > securityfs. With this conclusion I still think it is probably the best
> > > > > > > place for seurity policy like things even for SGX. It is meant for that
> > > > > > > anyway.
> > > > > > >
> > > > > >
> > > > > > LSM or DAC policy can certainly *restrict* it, but I suspect that most
> > > > > > container runtimes don't mount securityfs at all.  OTOH, the runtime
> > > > > > definitely needs to have a way to pass /dev/sgx/enclave (or whatever
> > > > > > it's called) through, so using another device node will definitely
> > > > > > work.
> > > > >
> > > > > OK, I can cope with this argument. I go with the device names above for
> > > > > v20.
> > > >
> > > > In v20 the refactoring would be with corresponding modes:
> > > >
> > > > /dev/sgx 0755
> > > > /dev/sgx/enclave 0666
> > > > /dev/sgx/provision 0600
> > > >
> > > > The problem that I'm facing is that with devnode callback of struct
> > > > device_type I can easily give the defaut mode for any of the files but
> > > > not for the /dev/sgx directory itself. How do I get the appropriate
> > > > mode for it?
> > > >
> > > 
> > > Hi Greg-
> > > 
> > > Do you know this one?
> > 
> > I guess one option is to not do anything with the mode but instead
> > contribute rules to udev? I'm not too familiar with this but maybe
> > that is even recommended way?
> 
> Why do you care about the directory permissions?  They should not
> matter, only the permissions on the device nodes themselves, right?

OK, based on your response to Andy I don't :-)

Thanks.

/Jarkko
