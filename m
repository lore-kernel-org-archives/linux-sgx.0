Return-Path: <SRS0=b5m/=TW=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89031C282DD
	for <linux-sgx@archiver.kernel.org>; Wed, 22 May 2019 13:20:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 69BC5217F9
	for <linux-sgx@archiver.kernel.org>; Wed, 22 May 2019 13:20:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbfEVNUf (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 22 May 2019 09:20:35 -0400
Received: from mga18.intel.com ([134.134.136.126]:53383 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728447AbfEVNUf (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 22 May 2019 09:20:35 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 May 2019 06:20:34 -0700
X-ExtLoop1: 1
Received: from lbrom5-mobl.ger.corp.intel.com (HELO localhost) ([10.249.47.39])
  by fmsmga006.fm.intel.com with ESMTP; 22 May 2019 06:20:24 -0700
Date:   Wed, 22 May 2019 16:20:22 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
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
Message-ID: <20190522132022.GC31176@linux.intel.com>
References: <CALCETrVbgTCnPo=PAq0-KoaRwt--urrPzn==quAJ8wodCpkBkw@mail.gmail.com>
 <20190514204527.GC1977@linux.intel.com>
 <CALCETrX6aL367mMJh5+Y1Seznfu-AvhPV6P7GkWF4Dhu0GV8cw@mail.gmail.com>
 <20190515013031.GF1977@linux.intel.com>
 <CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com>
 <20190517000331.GD11204@linux.intel.com>
 <CALCETrWxw7xALE0kmiYBzomaSMAeXEVq-7rX7xeqPtDPeDQiCA@mail.gmail.com>
 <20190520114105.GD27805@linux.intel.com>
 <20190521151836.GA4843@linux.intel.com>
 <20190521155140.GE22089@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190521155140.GE22089@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Tue, May 21, 2019 at 08:51:40AM -0700, Sean Christopherson wrote:
> Except that mmap() is more or less required to guarantee that ELRANGE
> established by ECREATE is available.  And we want to disallow mmap() as
> soon as the first EADD is done so that userspace can't remap the enclave's
> VMAs via munmap()->mmap() and gain execute permissions to pages that were
> EADD'd as NX.

We don't want to guarantee such thing and it is not guaranteed. It does
not fit at all to the multi process work done. Enclaves are detached
from any particular process addresse spaces. It is responsibility of
process to open windows to them.

That would be completely against work that we've done lately.

> Actually, conceptually it's probably more intuitive to disallow mmap() at
> ECREATE, i.e. the act of creating an enclave pins the associated virtual
> address range until the enclave is destroyed.

/Jarkko
