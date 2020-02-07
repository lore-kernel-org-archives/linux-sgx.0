Return-Path: <SRS0=sx24=33=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F3C6C2BA83
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Feb 2020 17:03:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 004CF21927
	for <linux-sgx@archiver.kernel.org>; Fri,  7 Feb 2020 17:03:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgBGRDj (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 7 Feb 2020 12:03:39 -0500
Received: from mga05.intel.com ([192.55.52.43]:8882 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726867AbgBGRDj (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 7 Feb 2020 12:03:39 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 07 Feb 2020 09:03:39 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,414,1574150400"; 
   d="scan'208";a="432625760"
Received: from hhuan26-mobl1.amr.corp.intel.com ([10.254.45.144])
  by fmsmga006.fm.intel.com with ESMTP; 07 Feb 2020 09:03:37 -0800
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org,
        "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>
Cc:     akpm@linux-foundation.org, dave.hansen@intel.com,
        sean.j.christopherson@intel.com, nhorman@redhat.com,
        npmccallum@redhat.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, kai.svahn@intel.com, bp@alien8.de,
        josh@joshtriplett.org, luto@kernel.org, kai.huang@intel.com,
        rientjes@google.com, cedric.xing@intel.com, puiterwijk@redhat.com,
        "Jarkko Sakkinen" <jarkko.sakkinen@intel.com>,
        linux-security-module@vger.kernel.org, haitao.huang@linux.intel.com
Subject: Re: [PATCH v25 10/21] x86/sgx: Linux Enclave Driver
References: <20200204060545.31729-1-jarkko.sakkinen@linux.intel.com>
 <20200204060545.31729-11-jarkko.sakkinen@linux.intel.com>
Date:   Fri, 07 Feb 2020 11:03:37 -0600
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.0fmm0bufwjvjmi@hhuan26-mobl1.amr.corp.intel.com>
In-Reply-To: <20200204060545.31729-11-jarkko.sakkinen@linux.intel.com>
User-Agent: Opera Mail/1.0 (Win32)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

Tested-by: Haitao Huang<haitao.huang@linux.intel.com>
