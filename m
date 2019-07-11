Return-Path: <SRS0=cFJI=VI=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A61EEC71142
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 17:53:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7801720645
	for <linux-sgx@archiver.kernel.org>; Thu, 11 Jul 2019 17:53:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbfGKRxE (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 11 Jul 2019 13:53:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:18624 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726016AbfGKRxE (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 11 Jul 2019 13:53:04 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Jul 2019 10:53:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,479,1557212400"; 
   d="scan'208";a="364894021"
Received: from jolivell-mobl2.ger.corp.intel.com (HELO localhost) ([10.252.50.138])
  by fmsmga005.fm.intel.com with ESMTP; 11 Jul 2019 10:52:58 -0700
Date:   Thu, 11 Jul 2019 20:52:57 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, nhorman@redhat.com, npmccallum@redhat.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, Andy Lutomirski <luto@amacapital.net>,
        Dave Hansen <dave.hansen@linux.intel.com>
Subject: Re: [PATCH v20 22/28] x86/traps: Attempt to fixup exceptions in vDSO
 before signaling
Message-ID: <20190711175257.p5cyewqsp66nhtji@linux.intel.com>
References: <20190417103938.7762-1-jarkko.sakkinen@linux.intel.com>
 <20190417103938.7762-23-jarkko.sakkinen@linux.intel.com>
 <20190625154341.GA7046@linux.intel.com>
 <20190711155645.GD15067@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190711155645.GD15067@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: NeoMutt/20180716
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Jul 11, 2019 at 08:56:46AM -0700, Sean Christopherson wrote:
> On Tue, Jun 25, 2019 at 06:43:41PM +0300, Jarkko Sakkinen wrote:
> > Is there any obvious reason why #PF fixup is in its own patch and the
> > rest are collected to the same patch? I would not find it confusing if
> > there was one patch per exception but really don't get this division.
> 
> I split them due to SGX's funky #PF behavior with respect to th EPCM.
> I'm ok with them being squashed.

Right, better to add a note to the commit message if anything.

/Jarkko
