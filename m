Return-Path: <SRS0=njgX=TX=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 059A7C282DD
	for <linux-sgx@archiver.kernel.org>; Thu, 23 May 2019 19:58:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D4C642133D
	for <linux-sgx@archiver.kernel.org>; Thu, 23 May 2019 19:58:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731462AbfEWT6m (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 23 May 2019 15:58:42 -0400
Received: from mga14.intel.com ([192.55.52.115]:6299 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbfEWT6m (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 23 May 2019 15:58:42 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 May 2019 12:58:41 -0700
X-ExtLoop1: 1
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.36])
  by orsmga006.jf.intel.com with ESMTP; 23 May 2019 12:58:41 -0700
Date:   Thu, 23 May 2019 12:58:41 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
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
Message-ID: <20190523195840.GA17370@linux.intel.com>
References: <20190521151836.GA4843@linux.intel.com>
 <20190521155140.GE22089@linux.intel.com>
 <20190522132022.GC31176@linux.intel.com>
 <20190522132227.GD31176@linux.intel.com>
 <0e183cce-c4b4-0e10-dbb6-bd81bea58b66@tycho.nsa.gov>
 <20190522153836.GA24833@linux.intel.com>
 <CALCETrUS8xyF1JJmQs18BGTDhPRXf+s81BkMZCZwmY73r7M+zg@mail.gmail.com>
 <20190523023517.GA31950@linux.intel.com>
 <20190523102628.GC10955@linux.intel.com>
 <20190523141752.GA12078@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190523141752.GA12078@linux.intel.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, May 23, 2019 at 07:17:52AM -0700, Sean Christopherson wrote:
> On Thu, May 23, 2019 at 01:26:28PM +0300, Jarkko Sakkinen wrote:
> > On Wed, May 22, 2019 at 07:35:17PM -0700, Sean Christopherson wrote:
> > > But actually, there's no need to disallow mmap() after ECREATE since the
> > > LSM checks also apply to mmap(), e.g. FILE__EXECUTE would be needed to
> > > mmap() any enclave pages PROT_EXEC.  I guess my past self thought mmap()
> > > bypassed LSM checks?  The real problem is that mmap()'ng an existing
> > > enclave would require FILE__WRITE and FILE__EXECUTE, which puts us back
> > > at square one.
> > 
> > I'm lost with the constraints we want to set.
> 
> As is today, SELinux policies would require enclave loaders to have
> FILE__WRITE and FILE__EXECUTE permissions on /dev/sgx/enclave.  Presumably
> other LSMs have similar requirements.  Requiring all processes to have
> FILE__{WRITE,EXECUTE} permissions means the permissions don't add much
> value, e.g. they can't be used to distinguish between an enclave that is
> being loaded from an unmodified file and an enclave that is being
> generated on the fly, e.g. Graphene.
> 
> Looking back at Andy's mail, he was talking about requiring FILE__EXECUTE
> to run an enclave, so perhaps it's only FILE__WRITE that we're trying to
> special case.

Argh, as I was working through Andy's latest proposal I realized that I
was subconciously making FILE__READ imply FILE__EXECUTE.

The idea behind inheriting permissions from the source VMA is to exempt
"standard" enclaves from needing FILE__WRITE.  But if we don't add an
exemption for FILE__EXECUTE as well, then all enclaves need FILE__EXECUTE,
which means FILE__EXECUTE can't be used to identify the case where
userspace is mapping an inherited PROT_WRITE page as PROT_EXEC.  And if
the SGX magic exempts FILE__EXECUTE, then FILE__READ implies FILE__EXECUTE.

Yuck.
