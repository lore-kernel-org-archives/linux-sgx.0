Return-Path: <SRS0=LjX6=44=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6D75C0044D
	for <linux-sgx@archiver.kernel.org>; Wed, 11 Mar 2020 17:15:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2C19B20749
	for <linux-sgx@archiver.kernel.org>; Wed, 11 Mar 2020 17:15:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730431AbgCKRPW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Wed, 11 Mar 2020 13:15:22 -0400
Received: from mga03.intel.com ([134.134.136.65]:12743 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730236AbgCKRPV (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Wed, 11 Mar 2020 13:15:21 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Mar 2020 10:15:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,541,1574150400"; 
   d="scan'208";a="231756380"
Received: from hhuan26-mobl1.amr.corp.intel.com ([10.252.135.72])
  by orsmga007.jf.intel.com with ESMTP; 11 Mar 2020 10:15:18 -0700
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
To:     "Dr. Greg" <greg@enjellic.com>
Cc:     "Jarkko Sakkinen" <jarkko.sakkinen@linux.intel.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        linux-sgx@vger.kernel.org, akpm@linux-foundation.org,
        dave.hansen@intel.com, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, haitao.huang@intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, bp@alien8.de, josh@joshtriplett.org,
        luto@kernel.org, kai.huang@intel.com, rientjes@google.com,
        cedric.xing@intel.com, puiterwijk@redhat.com,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v28 14/22] selftests/x86: Add a selftest for SGX
References: <20200303233609.713348-1-jarkko.sakkinen@linux.intel.com>
 <20200303233609.713348-15-jarkko.sakkinen@linux.intel.com>
 <20200306053210.GA16297@wind.enjellic.com>
 <op.0g923rgpwjvjmi@hhuan26-mobl1.amr.corp.intel.com>
 <20200311091313.GA8094@wind.enjellic.com>
Date:   Wed, 11 Mar 2020 12:15:17 -0500
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From:   "Haitao Huang" <haitao.huang@linux.intel.com>
Organization: Intel Corp
Message-ID: <op.0hbrjrc1wjvjmi@hhuan26-mobl1.amr.corp.intel.com>
In-Reply-To: <20200311091313.GA8094@wind.enjellic.com>
User-Agent: Opera Mail/1.0 (Win32)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 11 Mar 2020 04:13:13 -0500, Dr. Greg <greg@enjellic.com> wrote:

...
>
> Do you remember, off the top of your head, having to address guard
> pages differently?
>
No, we did not make changes specific to guard pages.

Haitao
