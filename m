Return-Path: <SRS0=m9nj=TQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 931A4C04E84
	for <linux-sgx@archiver.kernel.org>; Thu, 16 May 2019 01:48:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6C2E020873
	for <linux-sgx@archiver.kernel.org>; Thu, 16 May 2019 01:48:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727581AbfEPBql (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 15 May 2019 21:46:41 -0400
Received: from mga06.intel.com ([134.134.136.31]:62043 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726990AbfEPBTK (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 15 May 2019 21:19:10 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 May 2019 18:19:09 -0700
X-ExtLoop1: 1
Received: from hhuan26-mobl.amr.corp.intel.com ([10.255.34.16])
  by orsmga006.jf.intel.com with ESMTP; 15 May 2019 18:19:04 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     "Andy Lutomirski" <luto@kernel.org>,
        "Sean Christopherson" <sean.j.christopherson@intel.com>
Cc:     "James Morris" <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        "LSM List" <linux-security-module@vger.kernel.org>,
        "Paul Moore" <paul@paul-moore.com>,
        "Stephen Smalley" <sds@tycho.nsa.gov>,
        "Eric Paris" <eparis@parisplace.org>, selinux@vger.kernel.org,
        "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>,
        "Jethro Beekman" <jethro@fortanix.com>,
        "Xing, Cedric" <cedric.xing@intel.com>,
        "Hansen, Dave" <dave.hansen@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Dr. Greg" <greg@enjellic.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "X86 ML" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "Ayoun, Serge" <serge.ayoun@intel.com>,
        "Katz-zamir, Shay" <shay.katz-zamir@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        "Andy Shevchenko" <andriy.shevchenko@linux.intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>,
        "Borislav Petkov" <bp@alien8.de>,
        "Josh Triplett" <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "David Rientjes" <rientjes@google.com>
Subject: Re: SGX vs LSM (Re: [PATCH v20 00/28] Intel SGX1 support)
Reply-To: haitao.huang@linux.intel.com
References: <960B34DE67B9E140824F1DCDEC400C0F4E886094@ORSMSX116.amr.corp.intel.com> <6da269d8-7ebb-4177-b6a7-50cc5b435cf4@fortanix.com> <CALCETrWCZQwg-TUCm58DVG43=xCKRsMe1tVHrR8vdt06hf4fWA@mail.gmail.com> <20190513102926.GD8743@linux.intel.com> <20190514104323.GA7591@linux.intel.com> <CALCETrVbgTCnPo=PAq0-KoaRwt--urrPzn==quAJ8wodCpkBkw@mail.gmail.com> <20190514204527.GC1977@linux.intel.com> <CALCETrX6aL367mMJh5+Y1Seznfu-AvhPV6P7GkWF4Dhu0GV8cw@mail.gmail.com> <20190515013031.GF1977@linux.intel.com> <CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com> <20190515213858.GG5875@linux.intel.com>
Date:   Wed, 15 May 2019 20:19:04 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel
Message-ID: <op.z1uy92bdwjvjmi@hhuan26-mobl.amr.corp.intel.com>
In-Reply-To: <20190515213858.GG5875@linux.intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 15 May 2019 16:38:58 -0500, Sean Christopherson  
<sean.j.christopherson@intel.com> wrote:

> On Wed, May 15, 2019 at 11:27:04AM -0700, Andy Lutomirski wrote:
>> 2) Just like any other DSO, there are potential issues with how
>> enclaves deal with writable vs executable memory.  This takes two
>> forms.  First, a task should probably require EXECMEM, EXECMOD, or
>> similar permission to run an enclave that can modify its own text.
>> Second, it would be nice if a task that did *not* have EXECMEM,
>> EXECMOD, or similar could still run the enclave if it had EXECUTE
>> permission on the file containing the enclave.
>>
>> Currently, this all works because DSOs are run by mmapping the file to
>> create multiple VMAs, some of which are executable, non-writable, and
>> non-CoWed, and some of which are writable but not executable.  With
>> SGX, there's only really one inode per enclave (the anon_inode that
>> comes form /dev/sgx/enclave), and it can only be sensibly mapped
>> MAP_SHARED.
>
> I was wrong when I said /dev/sgx/enclave creates and returns an anon
> inode.  I was thinking of the KVM model for creating VMs.  SGX creates
> an enclave when /dev/sgx/enclave is opened and associates the enclave
> with the newly opened /dev/sgx/enclave fd.
>
> Regardless, the fundamental problem remains, mmap() of EPC works on a
> single inode.

If I read code in file_map_prot_check() correctly, only when you request  
W+X at the same time that EXECMEM would be required for MAP_SHARED, right?
If so, I believe SGX enclaves would never need that.
