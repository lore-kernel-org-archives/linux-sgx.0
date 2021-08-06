Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26089C4338F
	for <linux-sgx@archiver.kernel.org>; Fri,  6 Aug 2021 11:24:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0BBF0611C6
	for <linux-sgx@archiver.kernel.org>; Fri,  6 Aug 2021 11:24:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245457AbhHFLZG (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Fri, 6 Aug 2021 07:25:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245456AbhHFLZF (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Fri, 6 Aug 2021 07:25:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A0BD660EE8;
        Fri,  6 Aug 2021 11:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628249090;
        bh=SHO6K0c5BYBCASZfdWQKTPTx1AGWXZ8zD6+WFz4xq0o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V7e/njGXRMlFQptqYHsVgoYhAlhC6pXGNLyaRpFOi5X/mYp3Wp/GxK1pcKWAqJ5Zp
         2HFwhFTmZhsT9SPcrbKStaZ11EZTpzgqT83CpwZ8Rk1HLVs+gdKGMDeFRTzwPkvwa0
         VonvEZC6g7F8dDRAAY6Fin15KHy6h+IXI42apvkP8YdqAaui2ryvcbBy8EAstee+04
         WfeqHtmyNnGbYx59znSLpIMClf/x+pr6VcqvusKEhrTjjV496p3G78wzxmz7OWHUtR
         SwEB/m/pxkCjiVElFxCvbKg61hKFybIQKQYRRbikPAhwavS2VHkocQuZEodh+Quxac
         vaKXYjqYnsB6g==
Date:   Fri, 6 Aug 2021 14:24:46 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Shuah Khan <shuah@kernel.org>
Cc:     linux-kselftest@vger.kernel.org, linux-sgx@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 6/8] selftests/sgx: Encpsulate the test enclave
 creation
Message-ID: <20210806112446.vfw3azdp6uh54plg@kernel.org>
References: <20210806001704.667889-1-jarkko@kernel.org>
 <20210806001704.667889-7-jarkko@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806001704.667889-7-jarkko@kernel.org>
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, Aug 06, 2021 at 03:17:02AM +0300, Jarkko Sakkinen wrote:
> +FIXTURE_SETUP(enclave)
> +{
> +	if (!setup_test_encl(ENCL_HEAP_SIZE_DEFAULT, &self->encl, _metadata))
> +		ASSERT_TRUE(false);

Probably would make more sense:

        ASSERT_TRUE(setup_test_encl(ENCL_HEAP_SIZE_DEFAULT, &self->encl, _metadata));

Right?

[and similar remarks to 7/8 and 8/8]

/Jarkko
