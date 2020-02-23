Return-Path: <SRS0=ol6i=4L=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3E6CC35671
	for <linux-sgx@archiver.kernel.org>; Sun, 23 Feb 2020 17:04:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3292206E2
	for <linux-sgx@archiver.kernel.org>; Sun, 23 Feb 2020 17:04:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbgBWREq (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 23 Feb 2020 12:04:46 -0500
Received: from mga17.intel.com ([192.55.52.151]:44863 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726208AbgBWREq (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 23 Feb 2020 12:04:46 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 23 Feb 2020 09:04:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,476,1574150400"; 
   d="scan'208";a="230915731"
Received: from ajbergin-mobl.ger.corp.intel.com (HELO localhost) ([10.252.23.203])
  by fmsmga008.fm.intel.com with ESMTP; 23 Feb 2020 09:04:38 -0800
Date:   Sun, 23 Feb 2020 19:04:37 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH v26 22/22] docs: x86/sgx: Document SGX micro architecture
 and kernel internals
Message-ID: <20200223170437.GB5074@linux.intel.com>
References: <01067247-f6ff-21f6-774f-cbb6e72bc99e@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01067247-f6ff-21f6-774f-cbb6e72bc99e@infradead.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Feb 21, 2020 at 08:13:02PM -0800, Randy Dunlap wrote:
> > +	``grep /proc/cpuinfo``
> 
> 	grep sgx /proc/cpuinfo
> 
> > +

Oops.

> > +Enclave Page Cache
> > +==================
> 
> ...
> 
> and
> Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thank you!

Updated here:

https://github.com/jsakkine-intel/linux-sgx/commit/ff441923faa78b0695402424f172aa5838e9f754

/Jarkko
