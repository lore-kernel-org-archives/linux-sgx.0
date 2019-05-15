Return-Path: <SRS0=97/O=TP=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97CC1C04E53
	for <linux-sgx@archiver.kernel.org>; Wed, 15 May 2019 09:58:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6FD232084A
	for <linux-sgx@archiver.kernel.org>; Wed, 15 May 2019 09:58:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbfEOJ6h (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 15 May 2019 05:58:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:11059 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725977AbfEOJ6h (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 15 May 2019 05:58:37 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 May 2019 02:58:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,472,1549958400"; 
   d="scan'208";a="171908010"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.189])
  by fmsmga002.fm.intel.com with ESMTP; 15 May 2019 02:58:31 -0700
Date:   Wed, 15 May 2019 12:58:40 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Christopherson, Sean J" <sean.j.christopherson@intel.com>,
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
Message-ID: <20190515095840.GA10917@linux.intel.com>
References: <979615a8-fd03-e3fd-fbdb-65c1e51afd93@fortanix.com>
 <8fe520bb-30bd-f246-a3d8-c5443e47a014@intel.com>
 <358e9b36-230f-eb18-efdb-b472be8438b4@fortanix.com>
 <960B34DE67B9E140824F1DCDEC400C0F4E886094@ORSMSX116.amr.corp.intel.com>
 <6da269d8-7ebb-4177-b6a7-50cc5b435cf4@fortanix.com>
 <CALCETrWCZQwg-TUCm58DVG43=xCKRsMe1tVHrR8vdt06hf4fWA@mail.gmail.com>
 <20190513102926.GD8743@linux.intel.com>
 <20190514104323.GA7591@linux.intel.com>
 <CALCETrVbgTCnPo=PAq0-KoaRwt--urrPzn==quAJ8wodCpkBkw@mail.gmail.com>
 <20190515084909.GA10043@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190515084909.GA10043@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, May 15, 2019 at 11:49:09AM +0300, Jarkko Sakkinen wrote:
> On Tue, May 14, 2019 at 08:13:36AM -0700, Andy Lutomirski wrote:
> > On Tue, May 14, 2019 at 3:43 AM Jarkko Sakkinen
> > <jarkko.sakkinen@linux.intel.com> wrote:
> > >
> > > On Mon, May 13, 2019 at 01:29:26PM +0300, Jarkko Sakkinen wrote:
> > > > I did study through SDK's file format and realized that it does not
> > > > does make sense after all to embed one.
> > > >
> > > > To implement it properly you would probably need a new syscall (lets say
> > > > sgx_load_enclave) and also that enclaves are not just executables
> > > > binaries. It is hard to find a generic format for them as applications
> > > > range from simply protecting part of an application to running a
> > > > containter inside enclave.
> > >
> > > I'm still puzzling what kind of changes you were discussing considering
> > > SGX_IOC_ENCLAVE_ADD_PAGE.
> > 
> > I think it's as simple as requiring that, if SECINFO.X is set, then
> > the src pointer points to the appropriate number of bytes of
> > executable memory.  (Unless there's some way for an enclave to change
> > SECINFO after the fact -- is there?)  Sadly, we don't really have the
> > a nice in-kernel API for that right now.  You could do
> > down_read(mmap_sem) and find_vma().  Arguably there is no value to
> > checking that PKRU allows execute to the data.
> 
> OK, so you would actually go on to check whether the VMA where the data
> is copied contains executable data?
> 
> What if SECINFO.X is not set and you EADD to region that is executable
> in the enclave VMA? E.g. have RWX VMA for the enclave just to give a
> simple example. Then you could carry executable code in the data
> sections of the binary.

This would require to be done after the enclave is initialized of course
with EMODPR, which requires the enclave to accept the permission change
with EACCEPT, which limits somewhat. This means that the static enclave
would be fully covered.

/Jarkko
