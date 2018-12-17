Return-Path: <SRS0=zBz/=O2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DC93C43387
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Dec 2018 19:54:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 385542133F
	for <linux-sgx@archiver.kernel.org>; Mon, 17 Dec 2018 19:54:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387428AbeLQTy4 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 17 Dec 2018 14:54:56 -0500
Received: from mga18.intel.com ([134.134.136.126]:64988 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726989AbeLQTy4 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 17 Dec 2018 14:54:56 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 17 Dec 2018 11:54:56 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,366,1539673200"; 
   d="scan'208";a="284253898"
Received: from quwen-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.254.215])
  by orsmga005.jf.intel.com with ESMTP; 17 Dec 2018 11:54:49 -0800
Date:   Mon, 17 Dec 2018 21:54:48 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Dave Hansen <dave.hansen@intel.com>,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        X86 ML <x86@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        linux-sgx@vger.kernel.org, nhorman@redhat.com,
        npmccallum@redhat.com, "Ayoun, Serge" <serge.ayoun@intel.com>,
        shay.katz-zamir@intel.com,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Svahn, Kai" <kai.svahn@intel.com>, mark.shanahan@intel.com,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Darren Hart <dvhart@infradead.org>,
        Andy Shevchenko <andy@infradead.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v17 18/23] platform/x86: Intel SGX driver
Message-ID: <20181217195448.GE29785@linux.intel.com>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-19-jarkko.sakkinen@linux.intel.com>
 <7d5cde02-4649-546b-0f03-2d6414bb80b5@intel.com>
 <20181217180102.GA12560@linux.intel.com>
 <20181217183613.GD12491@linux.intel.com>
 <20181217184333.GA26920@linux.intel.com>
 <ccfb67a0-fd8d-82c8-8018-fd68e901f287@intel.com>
 <CALCETrX0W4dhFJBHEbDbKed_QZxmw6ZNMajfsoVgqGqhMB0nDg@mail.gmail.com>
 <beea8ad3-a607-5478-ad87-b8dd33e86146@intel.com>
 <CALCETrUCAvsaO71422gbaJtuZTbx8Y7pUm7yF3zQkktOvRedzw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrUCAvsaO71422gbaJtuZTbx8Y7pUm7yF3zQkktOvRedzw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 17, 2018 at 11:25:47AM -0800, Andy Lutomirski wrote:
> On Mon, Dec 17, 2018 at 11:17 AM Dave Hansen <dave.hansen@intel.com> wrote:
> >
> > On 12/17/18 11:12 AM, Andy Lutomirski wrote:
> > > So I'm not saying that you shouldn't do it the way you are now, but I
> > > do think that the changelog or at least some emails should explain
> > > *why* the enclave needs to keep a pointer to the creating process's
> > > mm.  And, if you do keep the current model, it would be nice to
> > > understand what happens if you do something awful like mremap()ing an
> > > enclave, or calling madvise on it, or otherwise abusing the vma.  Or
> > > doing fork(), for that matter.
> >
> > Yeah, the code is built to have one VMA and only one VMA per enclave.
> > You need to go over the origin of this restriction and what enforces this.
> 
> There is a sad historical reason that you may regret keeping this
> restriction.  There are plenty of pieces of code out there that think
> it's reasonable to spawn a subprocess by calling fork() and then
> execve().  (This is *not* a sensible thing to do.  One should use
> posix_spawn() or some CLONE_VM variant.  But even fairly recent
> posix_spawn() implementations will fork().  So the driver has to do
> *something* sensible on fork() or a bunch of things that use SGX
> unsuspectingly via, for example, PKCS #11, are going to be very sad.
> I suppose you could make enclaves just not show up in the fork()ed
> children, but then you have a different problem: creating an enclave
> and then doing daemon() won't work.
> 
> Yes, POSIX traditions are rather silly.

ATM enclave VMAs are not copied on fork. Not sure how you would
implement COW semantics with enclaves.

/Jarkko
