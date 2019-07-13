Return-Path: <SRS0=72mU=VK=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EEF1C742A7
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Jul 2019 15:21:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 08CFA20838
	for <linux-sgx@archiver.kernel.org>; Sat, 13 Jul 2019 15:21:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727638AbfGMPV6 (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sat, 13 Jul 2019 11:21:58 -0400
Received: from mga07.intel.com ([134.134.136.100]:9345 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727626AbfGMPV6 (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sat, 13 Jul 2019 11:21:58 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jul 2019 08:21:57 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,486,1557212400"; 
   d="scan'208";a="177789632"
Received: from hbriegel-mobl.ger.corp.intel.com ([10.252.50.48])
  by orsmga002.jf.intel.com with ESMTP; 13 Jul 2019 08:21:52 -0700
Message-ID: <dddd9db0d2e7a4d4246ecbb096d0b35cd0aecb2a.camel@linux.intel.com>
Subject: Re: [RFC PATCH v4 3/3] selftests/x86/sgx: Augment SGX selftest to
 test vDSO API
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Cedric Xing <cedric.xing@intel.com>, linux-sgx@vger.kernel.org
Cc:     dave.hansen@intel.com, sean.j.christopherson@intel.com,
        serge.ayoun@intel.com, shay.katz-zamir@intel.com,
        haitao.huang@intel.com, kai.svahn@intel.com, kai.huang@intel.com
Date:   Sat, 13 Jul 2019 18:21:51 +0300
In-Reply-To: <657fe13cbf962d72dc1afc0e25577d8e89225702.1563000446.git.cedric.xing@intel.com>
References: <cover.1563000446.git.cedric.xing@intel.com>
         <657fe13cbf962d72dc1afc0e25577d8e89225702.1563000446.git.cedric.xing@intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, 2019-07-12 at 23:51 -0700, Cedric Xing wrote:
> This patch augments SGX selftest with two new tests.
> 
> The first test exercises the newly added callback interface, by marking the
> whole enclave range as PROT_READ, then calling mprotect() upon #PFs to add
> necessary PTE permissions per PFEC (#PF Error Code) until the enclave finishes.
> This test also serves as an example to demonstrate the callback interface.
> 
> The second test single-steps through __vdso_sgx_enter_enclave() to make sure
> the call stack can be unwound at every instruction within that vDSO API. Its
> purpose is to validate the hand-crafted CFI directives in the assembly.
> 
> Besides the new tests, this patch also fixes minor problems in the Makefile,
> such as:
>   * appended "--build-id=none" to ld command line to suppress the
>     ".note.gnu.build-id section discarded" linker warning.
>   * removed "--remove-section=.got.plt" from objcopy command line as that
>     section would never exist in statically linked (enclave) images.
> 
> Signed-off-by: Cedric Xing <cedric.xing@intel.com>

This is also in "unreviewable" state. And you ignored the comment about the
function names.

All I asked was patch that just changes the calling convention to send v21
and include the vDSO change. How hard can that be?

Also do not add the main LKML (linux-kernel@vger.kernel.org) to these patches
that are not directly against the mainline. That is only causing unnecessary
saturation and noise.

Thank you.

/Jarkko

