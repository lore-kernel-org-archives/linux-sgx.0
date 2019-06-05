Return-Path: <SRS0=6XgF=UE=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A776C28CC5
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Jun 2019 23:58:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2267F20830
	for <linux-sgx@archiver.kernel.org>; Wed,  5 Jun 2019 23:58:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfFEX6t (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 5 Jun 2019 19:58:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:55345 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726510AbfFEX6s (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 5 Jun 2019 19:58:48 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Jun 2019 16:58:47 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by FMSMGA003.fm.intel.com with ESMTP; 05 Jun 2019 16:58:46 -0700
Date:   Wed, 5 Jun 2019 16:58:46 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     "Ayoun, Serge" <serge.ayoun@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@parisplace.org>,
        "selinux@vger.kernel.org" <selinux@vger.kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>,
        "Roberts, William C" <william.c.roberts@intel.com>,
        "Tricca, Philip B" <philip.b.tricca@intel.com>
Subject: Re: [RFC PATCH 6/9] x86/sgx: Require userspace to provide allowed
 prots to ADD_PAGES
Message-ID: <20190605235846.GI26328@linux.intel.com>
References: <20190531233159.30992-1-sean.j.christopherson@intel.com>
 <20190531233159.30992-7-sean.j.christopherson@intel.com>
 <88B7642769729B409B4A93D7C5E0C5E7C64475FB@hasmsx108.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88B7642769729B409B4A93D7C5E0C5E7C64475FB@hasmsx108.ger.corp.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Jun 05, 2019 at 04:10:44AM -0700, Ayoun, Serge wrote:
> > From: Christopherson, Sean J
> > Sent: Saturday, June 01, 2019 02:32
> > 
> >  /**
> >   * struct sgx_enclave_add_pages - parameter structure for the
> >   *                                %SGX_IOC_ENCLAVE_ADD_PAGES ioctl
> > @@ -39,6 +44,7 @@ struct sgx_enclave_create  {
> >   * @secinfo:	address for the SECINFO data (common to all pages)
> >   * @nr_pages:	number of pages (must be virtually contiguous)
> >   * @mrmask:	bitmask for the measured 256 byte chunks (common to all
> > pages)
> > + * @flags:	flags, e.g. SGX_ALLOW_{READ,WRITE,EXEC} (common to all
> > pages)
> >   */
> >  struct sgx_enclave_add_pages {
> >  	__u64	addr;
> > @@ -46,7 +52,8 @@ struct sgx_enclave_add_pages {
> >  	__u64	secinfo;
> >  	__u32	nr_pages;
> >  	__u16	mrmask;
> > -} __attribute__((__packed__));
> > +	__u16	flags;
> > +};
> 
> You are adding a flags member. The secinfo structure has already a flags member in it.
> Why do you need both - they are both coming from user mode. What kind of scenario would
> require having different values. Seems confusing.

The format of SECINFO.FLAGS is hardware defined, e.g. we can't add a flag
to tag the page as being a zero page for optimization purposes, at least
not without breaking future compatibility or doing tricky overloading.

If you're specifically talking about SECINFO.FLAGS.RWX, due to SGX2 there
are scenarios where userspace will initially want the page to be RW, and
will later want to convert the page to RX.  Making decisions based solely
on the initial EPCM permissions would either create a security hole or
force SGX to track "dirty" pages along with a implementing a pre-check
scheme for LSMs (or restricting LSMs to tieing permissions to the host
process and not the enclave).
