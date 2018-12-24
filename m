Return-Path: <SRS0=n9z9=PB=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE844C43387
	for <linux-sgx@archiver.kernel.org>; Mon, 24 Dec 2018 11:55:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AD76220989
	for <linux-sgx@archiver.kernel.org>; Mon, 24 Dec 2018 11:55:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725298AbeLXLzh (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 24 Dec 2018 06:55:37 -0500
Received: from mga07.intel.com ([134.134.136.100]:30931 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725268AbeLXLzh (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 24 Dec 2018 06:55:37 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 24 Dec 2018 03:55:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,392,1539673200"; 
   d="scan'208";a="121343949"
Received: from dlu2-mobl4.ccr.corp.intel.com (HELO localhost) ([10.249.254.240])
  by orsmga001.jf.intel.com with ESMTP; 24 Dec 2018 03:55:30 -0800
Date:   Mon, 24 Dec 2018 13:55:29 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Jethro Beekman <jethro@fortanix.com>
Cc:     "x86@kernel.org" <x86@kernel.org>,
        "linux-sgx@vger.kernel.org" <linux-sgx@vger.kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "dave.hansen@intel.com" <dave.hansen@intel.com>,
        "sean.j.christopherson@intel.com" <sean.j.christopherson@intel.com>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "npmccallum@redhat.com" <npmccallum@redhat.com>,
        "serge.ayoun@intel.com" <serge.ayoun@intel.com>,
        "shay.katz-zamir@intel.com" <shay.katz-zamir@intel.com>,
        "haitao.huang@intel.com" <haitao.huang@intel.com>,
        "andriy.shevchenko@linux.intel.com" 
        <andriy.shevchenko@linux.intel.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "kai.svahn@intel.com" <kai.svahn@intel.com>,
        "bp@alien8.de" <bp@alien8.de>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>,
        "luto@kernel.org" <luto@kernel.org>
Subject: Re: [PATCH v18 18/25] x86/sgx: Add the Linux SGX Enclave Driver
Message-ID: <20181224115529.GC10971@linux.intel.com>
References: <20181221231154.6120-1-jarkko.sakkinen@linux.intel.com>
 <20181221231154.6120-19-jarkko.sakkinen@linux.intel.com>
 <303abbae-2c40-9ee4-6bc1-8848ad1850cd@fortanix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <303abbae-2c40-9ee4-6bc1-8848ad1850cd@fortanix.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Mon, Dec 24, 2018 at 05:36:25AM +0000, Jethro Beekman wrote:
> Documentation should specify which SECS fields should be passed by the
> user and which fields will be filled in by the kernel.

A really good point.

/Jarkko
