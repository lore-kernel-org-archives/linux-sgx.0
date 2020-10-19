Return-Path: <SRS0=Kf/c=D2=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A873C433E7
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Oct 2020 08:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A380022276
	for <linux-sgx@archiver.kernel.org>; Mon, 19 Oct 2020 08:46:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603097161;
	bh=ns4gZ1mwVZSCk6ZzrAfQoxcN/ZIrvw6e8hzbp7w4+mc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=sg7dviwn7+09mzZ8TxFl8ILD6CxiSR5EWuXM9aLfqg/WSRGq7rTUCy1O7J+jb6Ii6
	 IFS17DATQQ0NRFdljTlR+5uwp2QbjyoiMBJHkuI787/u5rKBrhbHwV+Y+ODcv40wvB
	 aTIT17JvpEfkWFP/P/7H1N05XLhhYgZzpVbEO5q4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729498AbgJSIqB (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Mon, 19 Oct 2020 04:46:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:33594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728683AbgJSIqB (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Mon, 19 Oct 2020 04:46:01 -0400
Received: from localhost (83-245-197-237.elisa-laajakaista.fi [83.245.197.237])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2ADD022257;
        Mon, 19 Oct 2020 08:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603097160;
        bh=ns4gZ1mwVZSCk6ZzrAfQoxcN/ZIrvw6e8hzbp7w4+mc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E5XDmR3HT3S/ad8lDGR3ZVvropnzZVoL9F/IkZD7WN3+TcrRGnCUSNJvxY3QDNVmh
         i5sRx0coIpu6gWh5lxQpCmvq0EQPvgm3E7ln2A3LdT8lTeP9Me34vjx/UO3gnpY7gs
         YyKFkwqvkUov38Z2ee582npwOKErxBlQqDuAx8YQ=
Date:   Mon, 19 Oct 2020 11:45:58 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Cc:     x86@kernel.org, linux-sgx@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Sean Christopherson <sean.j.christopherson@intel.com>,
        Jethro Beekman <jethro@fortanix.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Serge Ayoun <serge.ayoun@intel.com>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com, kai.huang@intel.com,
        kai.svahn@intel.com, kmoy@google.com, ludloff@google.com,
        luto@kernel.org, nhorman@redhat.com, npmccallum@redhat.com,
        puiterwijk@redhat.com, rientjes@google.com, tglx@linutronix.de,
        yaozhangx@google.com, mikko.ylinen@intel.com
Subject: Re: [PATCH v39 08/24] x86/sgx: Initialize metadata for Enclave Page
 Cache (EPC) sections
Message-ID: <20201019084558.GA1155569@kapsi.fi>
References: <20201003045059.665934-1-jarkko.sakkinen@linux.intel.com>
 <20201003045059.665934-9-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201003045059.665934-9-jarkko.sakkinen@linux.intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Sat, Oct 03, 2020 at 07:50:43AM +0300, Jarkko Sakkinen wrote:
> +config INTEL_SGX

Since the directory for this was renamed some iterations ago from
arch/x86/kernel/cpu/sgx to intel_sgx given the feedback from Boris,
I'm wondering should this also be renamed as X86_SGX?

/Jarkko
