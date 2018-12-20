Return-Path: <SRS0=1Eyi=O5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=MAILING_LIST_MULTI,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A2D1C43387
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Dec 2018 10:34:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 633D121720
	for <linux-sgx@archiver.kernel.org>; Thu, 20 Dec 2018 10:34:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728109AbeLTKeJ (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 20 Dec 2018 05:34:09 -0500
Received: from mga14.intel.com ([192.55.52.115]:6926 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727502AbeLTKeI (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 20 Dec 2018 05:34:08 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Dec 2018 02:34:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,376,1539673200"; 
   d="scan'208";a="131535725"
Received: from quwen-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.254.215])
  by fmsmga001.fm.intel.com with ESMTP; 20 Dec 2018 02:34:01 -0800
Date:   Thu, 20 Dec 2018 12:34:00 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Josh Triplett <josh@joshtriplett.org>,
        Haitao Huang <haitao.huang@linux.intel.com>
Subject: Re: x86/sgx: uapi change proposal
Message-ID: <20181220103400.GC26410@linux.intel.com>
References: <20181214215729.4221-1-sean.j.christopherson@intel.com>
 <7706b2aa71312e1f0009958bcab24e1e9d8d1237.camel@linux.intel.com>
 <598cd050-f0b5-d18c-96a0-915f02525e3e@fortanix.com>
 <20181219144343.GA31189@wind.enjellic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181219144343.GA31189@wind.enjellic.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Dec 19, 2018 at 08:43:43AM -0600, Dr. Greg wrote:
> I believe it is a silent response to the issues we were prosecuting
> 4-5 weeks ago, regarding the requirement for an SGX driver on an FLC
> hardware platform to have some semblance of policy management to be
> relevant from a security/privacy perspective.  It would have certainly
> been collegial to include a reference to our discussions and concerns
> in the changelog.
> 
> See 364f68f5a3c in Jarkko's next/master.
> 
> The changeset addresses enclave access to the PROVISION key but is
> still insufficient to deliver guarantees that are consistent with the
> SGX security model.  In order to achieve that, policy management needs
> to embrace the use of MRSIGNER values, which is what our SFLC patchset
> uses.
> 
> The noted changeset actually implements most of the 'kernel bloat'
> that our SFLC patchset needs to bolt onto.
> 
> As of yesterday afternoon next/master still won't initialize a
> non-trivial enclave.  Since there now appears to be a wholesale change
> in the driver architecture and UAPI we are sitting on the sidelines
> waiting for an indication all of that has some hope of working before
> we introduce our approach.
> 
> Part of SFLC won't be popular but it is driven by clients who are
> actually paying for SGX security engineering and architectures.

How many of these people are actually posting here?

/Jarkko
