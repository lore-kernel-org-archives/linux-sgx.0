Return-Path: <SRS0=7Hzq=T3=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F2A5C28CC0
	for <linux-sgx@archiver.kernel.org>; Mon, 27 May 2019 13:39:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8351E2147A
	for <linux-sgx@archiver.kernel.org>; Mon, 27 May 2019 13:39:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726697AbfE0Ni7 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 27 May 2019 09:38:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:30882 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726647AbfE0Ni7 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 27 May 2019 09:38:59 -0400
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 May 2019 06:38:58 -0700
X-ExtLoop1: 1
Received: from pgomulkx-mobl.ger.corp.intel.com (HELO localhost) ([10.251.94.230])
  by orsmga006.jf.intel.com with ESMTP; 27 May 2019 06:38:45 -0700
Date:   Mon, 27 May 2019 16:38:39 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Andy Lutomirski <luto@kernel.org>,
        Stephen Smalley <sds@tycho.nsa.gov>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        LSM List <linux-security-module@vger.kernel.org>,
        Paul Moore <paul@paul-moore.com>,
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
Message-ID: <20190527133839.GB9732@linux.intel.com>
References: <20190521155140.GE22089@linux.intel.com>
 <20190522132022.GC31176@linux.intel.com>
 <20190522132227.GD31176@linux.intel.com>
 <0e183cce-c4b4-0e10-dbb6-bd81bea58b66@tycho.nsa.gov>
 <20190522153836.GA24833@linux.intel.com>
 <CALCETrUS8xyF1JJmQs18BGTDhPRXf+s81BkMZCZwmY73r7M+zg@mail.gmail.com>
 <20190523023517.GA31950@linux.intel.com>
 <20190523102628.GC10955@linux.intel.com>
 <20190523141752.GA12078@linux.intel.com>
 <20190527133418.GA9732@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190527133418.GA9732@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, May 27, 2019 at 04:34:31PM +0300, Jarkko Sakkinen wrote:
> On Thu, May 23, 2019 at 07:17:52AM -0700, Sean Christopherson wrote:
> >   1. Do nothing.  Userspace would essentially be required to mmap() the
> >      enclave after EINIT, which is ugly but not breaking since userspace
> >      could mmap() the enclave with a placeholder VMA prior to building
> >      the enclave, and then a series of mmap() to establish its "real"
> >      mapping.
> 
> What it'd break to return error if mmap() is done before EINIT?
> 
> >   2. Propagate the permissions from EADD to the VMAs of the current mm
> >      if the entire EADD range is mapped and the mapping is PROT_NONE.
> 
> Right now you can do multiple mmap's. If the mmap's must be done after
> EINIT, the driver could check that permissions match the permissions in
> that range.
> 
> This leaves open how to deal with mprotect() but if the process does not
> have FILE__WRITE I guess you cannot do much.
> 
> >   3. Propagate the permissions from EADD to the VMAs of all mm structs
> >      that have mapped some piece of the enclave, following the matching
> >      rules from #2.
> 
> For me it looks that allowing mmap's only after EINIT would result the
> least confusing implemntation.

Obvious problem is of course the requirement of fixed mapping, which is
of course nasty.

/Jarkko
