Return-Path: <SRS0=I8pg=B5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E5EC433DF
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Aug 2020 21:23:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A2692063A
	for <linux-sgx@archiver.kernel.org>; Wed, 19 Aug 2020 21:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgHSVXX (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 19 Aug 2020 17:23:23 -0400
Received: from mga12.intel.com ([192.55.52.136]:30684 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726617AbgHSVXW (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 19 Aug 2020 17:23:22 -0400
IronPort-SDR: nHWf+TfeVtnLZhsJUORWFQDEj1a6OBGVM6JnHdOdQc2l1epUlNCO93tlU8ndpU15P3ZSLVCgE7
 BmUCgRetv4HA==
X-IronPort-AV: E=McAfee;i="6000,8403,9718"; a="134719952"
X-IronPort-AV: E=Sophos;i="5.76,332,1592895600"; 
   d="scan'208";a="134719952"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Aug 2020 14:23:14 -0700
IronPort-SDR: tRb8EujjyCF0q4Yu824iRPVt9sZdfq6cyYnW7g0yXcljMbzu3dvfpJL0L5Cm6fwDUYNkV/9e0T
 sBw2f1edk84A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,332,1592895600"; 
   d="scan'208";a="400947509"
Received: from abojanow-mobl4.ger.corp.intel.com (HELO localhost) ([10.252.52.107])
  by fmsmga001.fm.intel.com with ESMTP; 19 Aug 2020 14:23:08 -0700
Date:   Thu, 20 Aug 2020 00:23:07 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Nathaniel McCallum <npmccallum@redhat.com>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        X86 ML <x86@kernel.org>, linux-sgx@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Jethro Beekman <jethro@fortanix.com>,
        Cedric Xing <cedric.xing@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        asapek@google.com, Borislav Petkov <bp@alien8.de>,
        chenalexchen@google.com, Conrad Parker <conradparker@google.com>,
        cyhanish@google.com, Dave Hansen <dave.hansen@intel.com>,
        "Huang, Haitao" <haitao.huang@intel.com>,
        Josh Triplett <josh@joshtriplett.org>,
        "Huang, Kai" <kai.huang@intel.com>,
        "Svahn, Kai" <kai.svahn@intel.com>, Keith Moyer <kmoy@google.com>,
        Christian Ludloff <ludloff@google.com>,
        Andy Lutomirski <luto@kernel.org>,
        Neil Horman <nhorman@redhat.com>,
        Patrick Uiterwijk <puiterwijk@redhat.com>,
        David Rientjes <rientjes@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yaozhangx@google.com
Subject: Re: [PATCH v36 21/24] x86/vdso: Implement a vDSO for Intel SGX
 enclave call
Message-ID: <20200819212307.GG9942@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-22-jarkko.sakkinen@linux.intel.com>
 <CAOASepOqRfUafSv_qjUv-jW_6n8G7kZ9yh-2z_Z9sjL_2zqNCg@mail.gmail.com>
 <20200810222317.GG14724@linux.intel.com>
 <20200818145234.GC132200@linux.intel.com>
 <20200818150627.GD132200@linux.intel.com>
 <CAOASepNxu0YtSPjXynLaVgyt-S0uSad8HVrNgMNWf+Z7iamPvQ@mail.gmail.com>
 <20200818164353.GH137138@linux.intel.com>
 <CAOASepMABkAxMRY7fJr4bAqadYyVrhZkb0BmB8cTcXUL_VmwQw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOASepMABkAxMRY7fJr4bAqadYyVrhZkb0BmB8cTcXUL_VmwQw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Aug 19, 2020 at 09:33:45AM -0400, Nathaniel McCallum wrote:
> On Tue, Aug 18, 2020 at 12:44 PM Jarkko Sakkinen
> <jarkko.sakkinen@linux.intel.com> wrote:
> >
> > On Tue, Aug 18, 2020 at 11:15:32AM -0400, Nathaniel McCallum wrote:
> > > That seems like overkill to me. I'm just asking for one additional mov
> > > instruction. :)
> >
> > I started to consider eBPF since the complexity and constraints of the
> > callback look like an overkill and without doubt will be a burden to
> > maintain.
> 
> That feels to me like more complexity just to move the existing
> complexity from one place to another.

My thinking was that there is like two parts on AEX handler:

A. You have a set of data and some application dependent logic.
   Right now this part is written in assembly most of the time.
B. You have code that decide how to continue based on that logic.

I was thinking that you could have the logic manipulating data (the
existing context structure we have can be passed directly to the BPF
state machine) patchable with a BPF program.

The logic would be executed in ring-0. vDSO would contain part B.

It is better to at least make some rational conclusions about this
because it seems to be the trend [1].

On the other hand the history with callbacks has not been a history
of victory as far as it comes to all the possible issues with them.
Like think about signals for example...

[1] https://lwn.net/Articles/813261/

/Jarkko
