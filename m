Return-Path: <SRS0=97/O=TP=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F3DFC04E53
	for <linux-sgx@archiver.kernel.org>; Wed, 15 May 2019 13:21:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 357E02089E
	for <linux-sgx@archiver.kernel.org>; Wed, 15 May 2019 13:21:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726563AbfEONVt (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 15 May 2019 09:21:49 -0400
Received: from mga12.intel.com ([192.55.52.136]:41535 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726407AbfEONVt (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 15 May 2019 09:21:49 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 May 2019 06:21:48 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga004.fm.intel.com with ESMTP; 15 May 2019 06:21:47 -0700
Date:   Wed, 15 May 2019 06:21:47 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Jethro Beekman <jethro@fortanix.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Borislav Petkov <bp@alien8.de>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v20 00/28] Intel SGX1 support
Message-ID: <20190515132147.GA5875@linux.intel.com>
References: <8fe520bb-30bd-f246-a3d8-c5443e47a014@intel.com>
 <358e9b36-230f-eb18-efdb-b472be8438b4@fortanix.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E886094@ORSMSX116.amr.corp.intel.com>
 <6da269d8-7ebb-4177-b6a7-50cc5b435cf4@fortanix.com>
 <CALCETrWCZQwg-TUCm58DVG43=xCKRsMe1tVHrR8vdt06hf4fWA@mail.gmail.com>
 <20190513102926.GD8743@linux.intel.com>
 <20190514104323.GA7591@linux.intel.com>
 <CALCETrVbgTCnPo=PAq0-KoaRwt--urrPzn==quAJ8wodCpkBkw@mail.gmail.com>
 <20190514204527.GC1977@linux.intel.com>
 <20190515103531.GB10917@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515103531.GB10917@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, May 15, 2019 at 01:35:31PM +0300, Jarkko Sakkinen wrote:
> On Tue, May 14, 2019 at 01:45:27PM -0700, Sean Christopherson wrote:
> > On Tue, May 14, 2019 at 08:13:36AM -0700, Andy Lutomirski wrote:
> > > I think it's as simple as requiring that, if SECINFO.X is set, then
> > > the src pointer points to the appropriate number of bytes of
> > > executable memory.  (Unless there's some way for an enclave to change
> > > SECINFO after the fact -- is there?)
> > 
> > Nit: SECINFO is just the struct passed to EADD, I think what you're really
> > asking is "can the EPCM permissions be changed after the fact".
> > 
> > And the answer is, yes.
> > 
> > On SGX2 hardware, the enclave can extend the EPCM permissions at runtime
> > via ENCLU[EMODPE], e.g. to make a page writable.
> 
> Small correction: it is EMODPR.

No, I'm referring to EMODPE, note the ENCLU classification.

> Anyway, it is good to mention that these would require EACCEPT from the
> enclave side. In order to take advantage of this is in a malicous
> enclave, one would require SELinux/IMA/whatnot policy to have permitted
> it in the first place.

EMODPE doesn't require EACCEPT or any equivalent from the kernel.  As
you alluded to, the page tables would still need to allow PROT_EXEC.  I
was simply trying to answer Andy's question regarding SECINFO.

> Thus, it cannot be said that it breaks the security policy if this would
> happen because policy has allowed to use the particular enclave.
