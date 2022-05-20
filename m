Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AE67C433EF
	for <linux-sgx@archiver.kernel.org>; Fri, 20 May 2022 19:08:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353174AbiETTIu (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 20 May 2022 15:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236050AbiETTIt (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Fri, 20 May 2022 15:08:49 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115E8195EA4
        for <linux-sgx@vger.kernel.org>; Fri, 20 May 2022 12:08:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 62943CE2C70
        for <linux-sgx@vger.kernel.org>; Fri, 20 May 2022 19:08:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27BD3C385AA;
        Fri, 20 May 2022 19:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653073724;
        bh=JaWPUPPuvHrfzxtYJ6UOrlXXbMEroC8ycqNzhjJiqkA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hpu7llqccBZ/+C7sHCpTZGsn+XSxO7Ap3IAPjPVvqtTLg/T7F9RzdVgUeb6FCP34k
         lovhvsHZPqJHn6nDQTv10qr547EWC7OhWe1HJh0K5VyuKN1iLeiBnmBeu1lbNnSM44
         9GB9BFAoBtaAtIdXXGUaLbo4unxvBmYB7ExtzQu+EzG5jhdhGKzbdC8q2XY4UxGe+d
         aBppPBJMGUHsvLEbGrRgN3TF3NxBvhbJjv4rnjc5nTzCY64ojcJMEeXfLUgzGc/yuf
         8QGAN4/u37EJSIraTe89ufk00IVTNTdwrMR9AMRCCuq8P8pEaZv+ELqwDGh6wGdxez
         RmRkI5EODxXdQ==
Date:   Fri, 20 May 2022 22:07:06 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Cathy Zhang <cathy.zhang@intel.com>
Cc:     linux-sgx@vger.kernel.org, x86@kernel.org,
        reinette.chatre@intel.com, dave.hansen@intel.com,
        ashok.raj@intel.com, chao.p.peng@linux.intel.com,
        yang.zhong@intel.com
Subject: Re: [PATCH v5 2/9] x86/sgx: Save enclave pointer for VA page
Message-ID: <Yofm2hDXF2KCNnL7@iki.fi>
References: <20220520103904.1216-1-cathy.zhang@intel.com>
 <20220520103904.1216-3-cathy.zhang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220520103904.1216-3-cathy.zhang@intel.com>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, May 20, 2022 at 06:38:57PM +0800, Cathy Zhang wrote:
> Tearing down all enclaves is required by SGX SVN update, which
> involves running the ENCLS[EREMOVE] instruction on every EPC
> page. This (tearing down all enclaves) should be coordinated
> with any enclaves that may be in the process of existing and thus
> already be running ENCLS[EREMOVE] as part of enclave release.
> 
> In support of this coordination, it is required to know which enclave
> owns each in-use EPC page. It is already possible to locate the
> owning enclave of SECS and regular pages but not for VA pages.
> 
> Make the following changes for VA pages' location:
> 1) Make epc->owner type-agnostic by changing its type to 'void *'. So,
>    besides "struct sgx_encl_page", it can have other types, like
>    "struct sgx_va_page".
> 2) Save the enclave pointer for each VA page to support locating its
>    owning enclave.

Enumeration lists imply that you would better to split this into 
two patches.

BR, Jarkko
