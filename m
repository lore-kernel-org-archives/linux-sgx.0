Return-Path: <SRS0=/KO+=TU=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_MUTT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 014DFC04AAC
	for <linux-sgx@archiver.kernel.org>; Mon, 20 May 2019 11:30:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D1E1A20644
	for <linux-sgx@archiver.kernel.org>; Mon, 20 May 2019 11:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732829AbfETL36 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 20 May 2019 07:29:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:40347 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731225AbfETL35 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 20 May 2019 07:29:57 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 May 2019 04:29:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.60,491,1549958400"; 
   d="scan'208";a="173589444"
Received: from mhauser-mobl.ger.corp.intel.com (HELO localhost) ([10.252.47.244])
  by fmsmga002.fm.intel.com with ESMTP; 20 May 2019 04:29:46 -0700
Date:   Mon, 20 May 2019 14:29:45 +0300
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
Message-ID: <20190520112945.GA27805@linux.intel.com>
References: <20190513102926.GD8743@linux.intel.com>
 <20190514104323.GA7591@linux.intel.com>
 <CALCETrVbgTCnPo=PAq0-KoaRwt--urrPzn==quAJ8wodCpkBkw@mail.gmail.com>
 <20190514204527.GC1977@linux.intel.com>
 <CALCETrX6aL367mMJh5+Y1Seznfu-AvhPV6P7GkWF4Dhu0GV8cw@mail.gmail.com>
 <20190515013031.GF1977@linux.intel.com>
 <CALCETrXf8mSK45h7sTK5Wf+pXLVn=Bjsc_RLpgO-h-qdzBRo5Q@mail.gmail.com>
 <20190516051622.GC6388@linux.intel.com>
 <CALCETrVx1hgY67mP+73w5rT+eY+APcfS0YJ+XwtTLNz3CbVNMA@mail.gmail.com>
 <20190516224550.GC11204@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190516224550.GC11204@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, May 16, 2019 at 03:45:50PM -0700, Sean Christopherson wrote:
> On Thu, May 16, 2019 at 02:02:58PM -0700, Andy Lutomirski wrote:
> > > On May 15, 2019, at 10:16 PM, Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com> wrote:
> > > There is a problem here though. Usually the enclave itself is just a
> > > loader that then loads the application from outside source and creates
> > > the executable pages from the content.
> > >
> > > A great example of this is Graphene that bootstraps unmodified Linux
> > > applications to an enclave:
> > >
> > > https://github.com/oscarlab/graphene
> > >
> > 
> > ISTM you should need EXECMEM or similar to run Graphene, then.
> 
> Agreed, Graphene is effectively running arbitrary enclave code.  I'm
> guessing there is nothing that prevents extending/reworking Graphene to
> allow generating the enclave ahead of time so as to avoid populating the
> guts of the enclave at runtime, i.e. it's likely possible to run an
> unmodified application in an enclave without EXECMEM if that's something
> Graphene or its users really care about.

I'd guess that also people adding SGX support to containers want
somewhat similar framework to work on so that you can just wrap a
container with an enclave.

/Jarkko
