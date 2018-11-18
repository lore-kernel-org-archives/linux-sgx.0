Return-Path: <SRS0=OFrI=N5=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A2CDC43441
	for <linux-sgx@archiver.kernel.org>; Sun, 18 Nov 2018 08:38:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4CDB220659
	for <linux-sgx@archiver.kernel.org>; Sun, 18 Nov 2018 08:38:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4CDB220659
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-sgx-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726077AbeKRS6I (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 18 Nov 2018 13:58:08 -0500
Received: from mga03.intel.com ([134.134.136.65]:52501 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726746AbeKRS6H (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 18 Nov 2018 13:58:07 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Nov 2018 00:38:29 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.56,247,1539673200"; 
   d="scan'208";a="107227431"
Received: from kaczmarx-mobl.ger.corp.intel.com (HELO localhost) ([10.249.254.89])
  by fmsmga004.fm.intel.com with ESMTP; 18 Nov 2018 00:38:20 -0800
Date:   Sun, 18 Nov 2018 10:38:16 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     x86@kernel.org, platform-driver-x86@vger.kernel.org,
        linux-sgx@vger.kernel.org, sean.j.christopherson@intel.com,
        nhorman@redhat.com, npmccallum@redhat.com, serge.ayoun@intel.com,
        shay.katz-zamir@intel.com, haitao.huang@linux.intel.com,
        andriy.shevchenko@linux.intel.com, tglx@linutronix.de,
        kai.svahn@intel.com, mark.shanahan@intel.com, luto@amacapital.net,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@kernel.org>,
        "open list:X86 ARCHITECTURE (32-BIT AND 64-BIT)" 
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v17 07/23] x86/mm: x86/sgx: Add new 'PF_SGX' page fault
 error code bit
Message-ID: <20181118083816.GN5897@linux.intel.com>
References: <20181116010412.23967-1-jarkko.sakkinen@linux.intel.com>
 <20181116010412.23967-8-jarkko.sakkinen@linux.intel.com>
 <38993cf5-039a-d582-1759-876cb948c582@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <38993cf5-039a-d582-1759-876cb948c582@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Nov 16, 2018 at 03:33:35PM -0800, Dave Hansen wrote:
> On 11/15/18 5:01 PM, Jarkko Sakkinen wrote:
> > The SGX bit is set in the #PF error code if and only if the fault is
> > detected by the Enclave Page Cache Map (EPCM), a hardware-managed
> > table that enforces the paging permissions defined by the enclave,
> > e.g. to prevent the kernel from changing the permissions of an
> > enclave's page(s).
> 
> This should probably also mention that, despite being a page fault,
> X86_PF_SGX has nothing to do with paging itself.

A valid point.

/Jarkko
