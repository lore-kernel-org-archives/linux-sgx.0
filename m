Return-Path: <SRS0=E9YI=32=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BF97C2D0B1
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Feb 2020 14:51:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EF90D21775
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Feb 2020 14:51:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbgBFOvk (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 6 Feb 2020 09:51:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:60948 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727501AbgBFOue (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 6 Feb 2020 09:50:34 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 06 Feb 2020 06:50:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,410,1574150400"; 
   d="scan'208";a="279692433"
Received: from dgbrowne-mobl.ger.corp.intel.com (HELO localhost) ([10.252.14.106])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Feb 2020 06:50:28 -0800
Date:   Thu, 6 Feb 2020 16:50:27 +0200
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
Subject: Re: [PATCH v25 21/21] docs: x86/sgx: Document SGX micro architecture
 and kernel internals
Message-ID: <20200206145027.GA8148@linux.intel.com>
References: <20200204060545.31729-1-jarkko.sakkinen@linux.intel.com>
 <20200204060545.31729-22-jarkko.sakkinen@linux.intel.com>
 <5ea28632-cd64-bc26-fab6-2868142eb9e4@infradead.org>
 <20200205230756.GB28111@linux.intel.com>
 <64d57033-cd19-ae6f-48c5-d7e01a97ad5e@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64d57033-cd19-ae6f-48c5-d7e01a97ad5e@infradead.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, Feb 05, 2020 at 03:10:47PM -0800, Randy Dunlap wrote:
> On 2/5/20 3:07 PM, Jarkko Sakkinen wrote:
> > I rewrote it as:
> > 
> > "Intel provides a proprietary binary version of the PCE. This is a
> > necessity when the software needs to prove to be running inside a legit
> 
> s/legit/legitimate/ please
> 
> > enclave on real hardware."

Hmm, actually it reads what I have now in the repository already
legitimate [1] :-) I guess I changed the text still after sending
the email.

Thank you for such detailed comments.

[1] https://github.com/jsakkine-intel/linux-sgx/blob/master/Documentation/x86/sgx.rst1

/Jarkko
