Return-Path: <SRS0=m9nj=TQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61805C04AB4
	for <linux-sgx@archiver.kernel.org>; Thu, 16 May 2019 05:16:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 366F420818
	for <linux-sgx@archiver.kernel.org>; Thu, 16 May 2019 05:16:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726257AbfEPFQX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 16 May 2019 01:16:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:58065 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725975AbfEPFQX (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 16 May 2019 01:16:23 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 15 May 2019 22:16:22 -0700
X-ExtLoop1: 1
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.189])
  by orsmga003.jf.intel.com with ESMTP; 15 May 2019 22:16:12 -0700
Date:   Thu, 16 May 2019 08:16:22 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
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
Message-ID: <20190516051622.GC6388@linux.intel.com>
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
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, May 15, 2019 at 11:27:04AM -0700, Andy Lutomirski wrote:
> Hi, LSM and SELinux people-
> 
> We're trying to figure out how SGX fits in with LSMs.  For background,
> an SGX library is functionally a bit like a DSO, except that it's
> nominally resistant to attack from outside and the process of loading
> it is complicated.  To load an enclave, a program can open
> /dev/sgx/enclave, do some ioctls to load the code and data segments
> into the enclave, call a special ioctl to "initialize" the enclave,
> and then call into the enclave (using special CPU instructions).
> 
> One nastiness is that there is not actually a universally agreed upon,
> documented file format for enclaves.  Windows has an undocumented
> format, and there are probably a few others out there.  No one really
> wants to teach the kernel to parse enclave files.
> 
> There are two issues with how this interacts with LSMs:
> 
> 1) LSMs might want to be able to whitelist, blacklist, or otherwise
> restrict what enclaves can run at all.  The current proposal that
> everyone seems to dislike the least is to have a .sigstruct file on
> disk that contains a hash and signature of the enclave in a
> CPU-defined format.  To initialize an enclave, a program will pass an
> fd to this file, and a new LSM hook can be called to allow or disallow
> the operation.  In a SELinux context, the idea is that policy could
> require the .sigstruct file to be labeled with a type like
> sgx_sigstruct_t, and only enclaves that have a matching .sigstruct
> with such a label could run.

Similarly if we could take data for the enclave from fd and enforce
it with sgx_enclave_t label.

> Here's a very vague proposal that's kind of like what I've been
> thinking over the past few days.  The SGX inode could track, for each
> page, a "safe-to-execute" bit.  When you first open /dev/sgx/enclave,
> you get a blank enclave and all pages are safe-to-execute.  When you
> do the ioctl to load context (which could be code, data, or anything
> else), the kernel will check whether the *source* VMA is executable
> and, if not, mark the page of the enclave being loaded as unsafe.
> Once the enclave is initialized, the driver will clear the
> safe-to-execute bit for any page that is successfully mapped writably.

With the fd based model for source I'd mark SECINFO.W pages as unsafe
to execute and then check unsafe bit before applying lets say EMODT
or EMODPR.

There is a problem here though. Usually the enclave itself is just a
loader that then loads the application from outside source and creates
the executable pages from the content.

A great example of this is Graphene that bootstraps unmodified Linux
applications to an enclave:

https://github.com/oscarlab/graphene

/Jarkko
