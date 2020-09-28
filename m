Return-Path: <SRS0=em/l=DF=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 652AEC4346E
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 00:53:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 22BCC23A34
	for <linux-sgx@archiver.kernel.org>; Mon, 28 Sep 2020 00:53:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726420AbgI1Axx (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 27 Sep 2020 20:53:53 -0400
Received: from mga06.intel.com ([134.134.136.31]:52586 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726396AbgI1Axx (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 27 Sep 2020 20:53:53 -0400
IronPort-SDR: F3lTCFor3BehzZy68OTkrmPctt/VjcUb9UHcmo0AJU5NHqgrsmkBM60TVSI5OHXYVzH1DCp3tn
 Viv+ygcg54tw==
X-IronPort-AV: E=McAfee;i="6000,8403,9757"; a="223515588"
X-IronPort-AV: E=Sophos;i="5.77,312,1596524400"; 
   d="scan'208";a="223515588"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2020 17:53:52 -0700
IronPort-SDR: lxwidzLM4mRdV7zMs4wsmOkdU6oHCAdz+ZoVXa3zOb1YxW5go5cLMvTEwXPXE8YHyMdJYjfpXV
 3uRowWkLMbdA==
X-IronPort-AV: E=Sophos;i="5.77,312,1596524400"; 
   d="scan'208";a="488352400"
Received: from memara-mobl.ger.corp.intel.com (HELO localhost) ([10.252.49.157])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Sep 2020 17:53:45 -0700
Date:   Mon, 28 Sep 2020 03:53:47 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        Andy Lutomirski <luto@kernel.org>, X86 ML <x86@kernel.org>,
        linux-sgx@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Wilcox <willy@infradead.org>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        "Xing, Cedric" <cedric.xing@intel.com>, chenalexchen@google.com,
        Conrad Parker <conradparker@google.com>, cyhanish@google.com,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Neil Horman <nhorman@redhat.com>,
        Nathaniel McCallum <npmccallum@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
Subject: Re: [PATCH v38 10/24] mm: Add vm_ops->mprotect()
Message-ID: <20200928005347.GB6704@linux.intel.com>
References: <20200924200156.GA19127@linux.intel.com>
 <e4bcb25f-581a-da93-502b-b8f73e28286a@intel.com>
 <20200924202549.GB19127@linux.intel.com>
 <e25bfeaa-afb4-3928-eb80-50d90815eabb@intel.com>
 <20200924230501.GA20095@linux.intel.com>
 <b737fcab-bfde-90e1-1101-82d646a6f5b7@intel.com>
 <20200925000052.GA20333@linux.intel.com>
 <32fc9df4-d4aa-6768-aa06-0035427b7535@intel.com>
 <20200925194304.GE31528@linux.intel.com>
 <230ce6da-7820-976f-f036-a261841d626f@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <230ce6da-7820-976f-f036-a261841d626f@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Sep 25, 2020 at 12:53:35PM -0700, Dave Hansen wrote:
> On 9/25/20 12:43 PM, Sean Christopherson wrote:
> >> That means that the intent argument (SGX_PROT_*) is currently unused.
> > No, the intent argument is used (eventually) by SGX's ->mprotect()
> > implementation, i.e. sgx_mprotect() enforces that the actual protections are a
> > subset of the declared/intended protections.
> > 
> > If ->mprotect() is not merged, then it yes, it will be unused.
> 
> OK, I think I've got it.
> 
> I think I'm OK with adding ->mprotect().  As long as folks buy into the
> argument that intent needs to be checked at mmap() time, they obviously
> need to be checked at mprotect() too.
> 
> Jarkko, if you want to try and rewrite the changelog, capturing the
> discussion here and reply, I think I can ack the resulting patch.  I
> don't know if that will satisfy the request from Boris from an ack from
> a "mm person", but we can at least start there. :)

I think what it needs, based on what I've read, is the step by step
description of the EMODPE scenarion without this callback and with it.

I think other important thing to underline is that an LSM or any other
security measure can only do a sane decision when the enclave is loaded.
At that point we know the source (vm_file).

I.e. when you are doing mmap() or mprotect() you don't have that
information. The permissions kind of describe the contact made at that
point of time.

> Please be judicious in what you include in the changelog.  There's been
> a lot of detritus in them.  Let's keep it as short, sweet, simple and on
> topic as we can.

Of course.

/Jarkko
