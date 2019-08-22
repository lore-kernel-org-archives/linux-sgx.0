Return-Path: <SRS0=Yp/Y=WS=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D1A6C3A5A1
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 16:43:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0923823401
	for <linux-sgx@archiver.kernel.org>; Thu, 22 Aug 2019 16:43:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390083AbfHVQnW (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 22 Aug 2019 12:43:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:9238 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731880AbfHVQnW (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Thu, 22 Aug 2019 12:43:22 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 22 Aug 2019 09:43:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,417,1559545200"; 
   d="scan'208";a="262919383"
Received: from greathea-mobl2.ger.corp.intel.com ([10.252.39.37])
  by orsmga001.jf.intel.com with ESMTP; 22 Aug 2019 09:43:18 -0700
Message-ID: <5f0c7483ecd47cb69faad0dc5ce77104c8701892.camel@linux.intel.com>
Subject: Re: [PATCH 5/5] x86/sgx: Rename vm_prot_bits as max_vm_flags
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     linux-sgx@vger.kernel.org,
        Sean Christopherson <sean.j.christpherson@intel.com>,
        Shay Katz-zamir <shay.katz-zamir@intel.com>,
        Serge Ayoun <serge.ayoun@intel.com>
Date:   Thu, 22 Aug 2019 19:43:16 +0300
In-Reply-To: <20190822040046.GW29345@linux.intel.com>
References: <20190819152544.7296-1-jarkko.sakkinen@linux.intel.com>
         <20190819152544.7296-6-jarkko.sakkinen@linux.intel.com>
         <20190822040046.GW29345@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.2-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Wed, 2019-08-21 at 21:00 -0700, Sean Christopherson wrote:
> On Mon, Aug 19, 2019 at 06:25:44PM +0300, Jarkko Sakkinen wrote:
> > vm_prot_bits is very bad and misleading name for the field in struct
> > sgx_encl_page. What the field contains exactly is not @prot of
> > mprotect() but the *maximum* VM flags for the VMA that contains the
> > given enclave page.
> > 
> > Thus, the only viable name for the field is max_vm_flags. In functions
> > that also pass VM flags the parameter name is renamed from vm_prot_bits
> > to vm_flags.
> 
> Why not max_vm_prot_bits?  'vm_flags' implies the field contains all
> manner of VM_FLAGS.  The 'vm_prot_bits' name was derived from
> calc_vm_prot_bits() to provide this differentiation, especially since
> there's also a calc_vm_flag_bits(),

Squashed with vm_max_prot_bits.

/Jarkko

