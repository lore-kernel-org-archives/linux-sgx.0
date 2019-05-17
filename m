Return-Path: <SRS0=W/GT=TR=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4033BC46470
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 00:03:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A20820848
	for <linux-sgx@archiver.kernel.org>; Fri, 17 May 2019 00:03:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727477AbfEQADd (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 16 May 2019 20:03:33 -0400
Received: from mga12.intel.com ([192.55.52.136]:35471 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbfEQADd (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 16 May 2019 20:03:33 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 May 2019 17:03:32 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by fmsmga008.fm.intel.com with ESMTP; 16 May 2019 17:03:31 -0700
Date:   Thu, 16 May 2019 17:03:31 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        Eric Paris <eparis@parisplace.org>, selinux@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
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
Message-ID: <20190517000331.GD11204@linux.intel.com>
References: <960B34DE67B9E140824F1DCDEC400C0F4E886094@ORSMSX116.amr.corp.intel.com>
 <6da269d8-7ebb-4177-b6a7-50cc5b435cf4@fortanix.com>
 <CALCETrWCZQwg-TUCm58DVG43=xCKRsMe1tVHrR8vdt06hf4fWA@mail.gmail.com>
 <20190513102926.GD8743@linux.intel.com>
 <20190514104323.GA7591@linux.intel.com>
 <CALCETrVbgTCnPo=PAq0-KoaRwt--urrPzn==quAJ8wodCpkBkw@mail.gmail.com>
 <20190514204527.GC1977@linux.intel.com>
 <CALCETrX6aL367mMJh5+Y1Seznfu-AvhPV6P7GkWF4Dhu0GV8cw@mail.gmail.com>
 <20190515013031.GF1977@linux.intel.com>
 <CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, May 15, 2019 at 11:27:04AM -0700, Andy Lutomirski wrote:
> Here's a very vague proposal that's kind of like what I've been
> thinking over the past few days.  The SGX inode could track, for each
> page, a "safe-to-execute" bit.  When you first open /dev/sgx/enclave,
> you get a blank enclave and all pages are safe-to-execute.  When you
> do the ioctl to load context (which could be code, data, or anything
> else), the kernel will check whether the *source* VMA is executable
> and, if not, mark the page of the enclave being loaded as unsafe.
> Once the enclave is initialized, the driver will clear the
> safe-to-execute bit for any page that is successfully mapped writably.
> 
> The intent is that a page of the enclave is safe-to-execute if that
> page was populated from executable memory and not modified since then.
> LSMs could then enforce a policy that you can map an enclave page RX
> if the page is safe-to-execute, you can map any page you want for
> write if there are no executable mappings, and you can only map a page
> for write and execute simultaneously if you can EXECMOD permission.
> This should allow an enclave to be loaded by userspace from a file
> with EXECUTE rights.

I'm still confused as to why you want to track execute permissions on the
enclave pages and add SGX-specific LSM hooks.  Is there anything that
prevents userspace from building the enclave like any other DSO and then
copying it into enclave memory?  I feel like I'm missing something.

  1. Userspace loads enclave into regular memory, e.g. like a normal DSO.
     All mmap(), mprotect(), etc... calls are subject to all existing
     LSM policies.

  2. Userspace opens /dev/sgx/enclave to instantiate a new enclave.

  3. Userspace uses mmap() to allocate virtual memory for its enclave,
     again subject to all existing LSM policies (sane userspaces map it RO
     since the permissions eventually get tossed anyways).

  4. SGX subsystem refuses to service page faults for enclaves that have
     not yet been initialized, e.g. signals SIGBUS or SIGSEGV.

  5. Userspace invokes SGX ioctl() to copy enclave from regulary VMA to
     enclave VMA.

  6. SGX ioctl() propagates VMA protection-related flags from source VMA
     to enclave VMA, e.g. invokes mprotect_fixup().  Enclave VMA(s) may
     be split as part of this process.

  7. At all times, mprotect() calls on the enclave VMA are subject to
     existing LSM policies, i.e. it's not special cased for enclaves.


The SGX ioctl() would need to take mmap_sem for write, but we can mitigate
that issue by changing the ioctl() to take a range of memory instead of a
single page.  That'd also provide "EADD batching" that folks have
requested.
