Return-Path: <SRS0=8byu=O7=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 457F3C43387
	for <linux-sgx@archiver.kernel.org>; Sat, 22 Dec 2018 16:55:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1B8D4219FC
	for <linux-sgx@archiver.kernel.org>; Sat, 22 Dec 2018 16:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388014AbeLVQzV (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 22 Dec 2018 11:55:21 -0500
Received: from mga17.intel.com ([192.55.52.151]:8051 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725961AbeLVQzV (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 22 Dec 2018 11:55:21 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 21 Dec 2018 22:32:50 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,383,1539673200"; 
   d="scan'208";a="120391972"
Received: from ncanderx-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.238])
  by FMSMGA003.fm.intel.com with ESMTP; 21 Dec 2018 22:32:43 -0800
Date:   Sat, 22 Dec 2018 08:32:41 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Andy Lutomirski <luto@kernel.org>
Cc:     Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        Haitao Huang <haitao.huang@linux.intel.com>,
        "Dr . Greg Wettstein" <greg@enjellic.com>
Subject: Re: x86/sgx: uapi change proposal
Message-ID: <20181222063241.GA8895@linux.intel.com>
References: <20181214215729.4221-1-sean.j.christopherson@intel.com>
 <7706b2aa71312e1f0009958bcab24e1e9d8d1237.camel@linux.intel.com>
 <598cd050-f0b5-d18c-96a0-915f02525e3e@fortanix.com>
 <20181219091148.GA5121@linux.intel.com>
 <613c6814-4e71-38e5-444a-545f0e286df8@fortanix.com>
 <20181219144515.GA30909@linux.intel.com>
 <CALCETrW_8LnitFamYUU7POHFOJFxLO7ESFUdS=aeG_SOvHVPkw@mail.gmail.com>
 <20181221162825.GB26865@linux.intel.com>
 <CALCETrX+KisMCbptrnPSO79-YF4E3nR1XHt+a7hCs1GXsxAbtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrX+KisMCbptrnPSO79-YF4E3nR1XHt+a7hCs1GXsxAbtw@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Dec 21, 2018 at 09:12:46AM -0800, Andy Lutomirski wrote:
> /dev/sgx/enclave: Each instance is an enclave.
> 
> /dev/sgx/epc: Used to get raw EPC for KVM. Might have different
> permissions, perhaps 0660 and group kvm.
> 
> /dev/sgx/something_else: For when SGX v3 adds something else :)

Responding again to this anyway now that I have had time think about
it.

Here is now I see it:

1. /dev/sgx/enclave should be /dev/sgx as it is now.
2. /dev/sgx/epc should be something that you'd reach through /dev/kvm.
   This essentially a circular dependency. KVM uapi should provide
   KVM services. Now you sprinkle KVM uapi to two subsystems.
3. "something else" is securityfs (e.g. provisioning). That is kind of
   stuff that it is meant for.

I'm sorry but from my perspective this does not look too good no
matter what glasses I put on...

/Jarkko
