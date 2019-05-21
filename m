Return-Path: <SRS0=0zVQ=TV=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26148C04E87
	for <linux-sgx@archiver.kernel.org>; Tue, 21 May 2019 15:51:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 04094217D7
	for <linux-sgx@archiver.kernel.org>; Tue, 21 May 2019 15:51:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728144AbfEUPvl (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Tue, 21 May 2019 11:51:41 -0400
Received: from mga02.intel.com ([134.134.136.20]:55893 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727941AbfEUPvl (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Tue, 21 May 2019 11:51:41 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 May 2019 08:51:40 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga005.jf.intel.com with ESMTP; 21 May 2019 08:51:40 -0700
Date:   Tue, 21 May 2019 08:51:40 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
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
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
Message-ID: <20190521155140.GE22089@linux.intel.com>
References: <20190514104323.GA7591@linux.intel.com>
 <CALCETrVbgTCnPo=PAq0-KoaRwt--urrPzn==quAJ8wodCpkBkw@mail.gmail.com>
 <20190514204527.GC1977@linux.intel.com>
 <CALCETrX6aL367mMJh5+Y1Seznfu-AvhPV6P7GkWF4Dhu0GV8cw@mail.gmail.com>
 <20190515013031.GF1977@linux.intel.com>
 <CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com>
 <20190517000331.GD11204@linux.intel.com>
 <CALCETrWxw7xALE0kmiYBzomaSMAeXEVq-7rX7xeqPtDPeDQiCA@mail.gmail.com>
 <20190520114105.GD27805@linux.intel.com>
 <20190521151836.GA4843@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521151836.GA4843@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, May 21, 2019 at 06:19:37PM +0300, Jarkko Sakkinen wrote:
> On Mon, May 20, 2019 at 02:41:05PM +0300, Jarkko Sakkinen wrote:
> > On Thu, May 16, 2019 at 05:26:15PM -0700, Andy Lutomirski wrote:
> > > Is userspace actually requred to mmap() the enclave prior to EADDing things?
> > 
> > Nope, not since v20. Here is what I wrote about API to the kernel
> > documentation:
> > 
> > "The enclave life-cycle starts by opening `/dev/sgx/enclave`. After this
> > there is already a data structure inside kernel tracking the enclave
> > that is initially uncreated. After this a set of ioctl's can be used to
> > create, populate and initialize the enclave.
> > 
> > You can close (if you want) the fd after you've mmap()'d. As long as the
> > file is open the enclave stays alive so you might want to do that after
> > you don't need it anymore. Even munmap() won't destruct the enclave if
> > the file is open.  Neither will closing the fd as long as you have
> > mmap() done over the fd (even if it does not across the range defined in
> > SECS)."
> > 
> > Enclave can be created and initialized without doing a single mmap()
> > call.
> 
> We could even disallow mmap() before EINIT done. The way enclave
> management internally works right now is quite robust and completely
> detached from requiring process address space for anything.

Except that mmap() is more or less required to guarantee that ELRANGE
established by ECREATE is available.  And we want to disallow mmap() as
soon as the first EADD is done so that userspace can't remap the enclave's
VMAs via munmap()->mmap() and gain execute permissions to pages that were
EADD'd as NX.

Actually, conceptually it's probably more intuitive to disallow mmap() at
ECREATE, i.e. the act of creating an enclave pins the associated virtual
address range until the enclave is destroyed.
