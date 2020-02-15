Return-Path: <SRS0=Eu7F=4D=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69D55C352A3
	for <linux-sgx@archiver.kernel.org>; Sat, 15 Feb 2020 07:26:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4A673206D7
	for <linux-sgx@archiver.kernel.org>; Sat, 15 Feb 2020 07:26:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725839AbgBOH0k (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 15 Feb 2020 02:26:40 -0500
Received: from mga17.intel.com ([192.55.52.151]:35395 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbgBOH0j (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 15 Feb 2020 02:26:39 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Feb 2020 23:26:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,443,1574150400"; 
   d="scan'208";a="227855882"
Received: from kfinglet-mobl.ger.corp.intel.com (HELO localhost) ([10.252.22.140])
  by orsmga008.jf.intel.com with ESMTP; 14 Feb 2020 23:26:28 -0800
Date:   Sat, 15 Feb 2020 09:26:29 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v26 19/22] x86/vdso: Add __vdso_sgx_enter_enclave() to
 wrap SGX enclave transitions
Message-ID: <20200215072629.GC9958@linux.intel.com>
References: <20200209212609.7928-1-jarkko.sakkinen@linux.intel.com>
 <20200209212609.7928-20-jarkko.sakkinen@linux.intel.com>
 <2b61b106-4dfd-ed47-3333-99280e33ca88@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b61b106-4dfd-ed47-3333-99280e33ca88@fortanix.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, Feb 13, 2020 at 02:29:44PM +0100, Jethro Beekman wrote:
> Tested-by: Jethro Beekman <jethro@fortanix.com>

Thank you.

/Jarkko
