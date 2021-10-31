Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4474FC433F5
	for <linux-sgx@archiver.kernel.org>; Sun, 31 Oct 2021 17:50:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2450D6108B
	for <linux-sgx@archiver.kernel.org>; Sun, 31 Oct 2021 17:50:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229853AbhJaRwg (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Sun, 31 Oct 2021 13:52:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229732AbhJaRwf (ORCPT <rfc822;linux-sgx@vger.kernel.org>);
        Sun, 31 Oct 2021 13:52:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 011B66108B;
        Sun, 31 Oct 2021 17:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635702603;
        bh=D9K++IiZhqgATou7mfyvBPPfy8a25d6NDtNfovMr3Zk=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=teGtL7raAEqu4HnqhV+ubKJs2k8/8oOjjDWehK2krBsbCz7+E+A0Mk7zncO9nUKfO
         9HOy1lrpLwKsL6SJh18dzNEAjKTJIVilaHfdnEUzOJEAvuhr/p9qv+kuWNTa7VKMi2
         j5ZfVnsQYzARdsaFj4m4rdFNo0cNeEnMIY1v6u/M0VmyAHGeRbv5KdRuBBM+IcyiWI
         LyIXeUBkkWP99V7UEfLrLKlFisJdQ4f+Tb1SpMjerDM/fcAfSRYGCDN0J3g+CqjlpD
         YRvgJzE+YhAtzcI3YX5tAVRxgM3QoZkyHbRGcRBvdwYO9/yWLOf1lmGl87ug6tnM/9
         /rHYTx69Desxw==
Message-ID: <c8af735b9243c5cab640681dd188f17c7b3018e8.camel@kernel.org>
Subject: Re: [PATCH] x86/sgx: SGX documentation fixes
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>,
        linux-sgx@vger.kernel.org, dave.hansen@linux.intel.com
Cc:     linux-kernel@vger.kernel.org
Date:   Sun, 31 Oct 2021 19:50:01 +0200
In-Reply-To: <ab99a87368eef69e3fb96f073368becff3eff874.1635529506.git.reinette.chatre@intel.com>
References: <ab99a87368eef69e3fb96f073368becff3eff874.1635529506.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Fri, 2021-10-29 at 10:49 -0700, Reinette Chatre wrote:
> SGX documentation fixes are:
>=20
> =C2=A0* Remove capitalization from regular words in the middle of a sente=
nce.
> =C2=A0* Remove punctuation found in the middle of a sentence.
> =C2=A0* Fix name of SGX daemon to consistently be ksgxd.
> =C2=A0* Fix typo of SGX instruction: ENIT -> EINIT
>=20
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>

Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>

/Jarkko

