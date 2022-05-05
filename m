Return-Path: <linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FC69C433EF
	for <linux-sgx@archiver.kernel.org>; Thu,  5 May 2022 06:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244155AbiEEGLn (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 5 May 2022 02:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243273AbiEEGLm (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 5 May 2022 02:11:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C76AB3E5C0
        for <linux-sgx@vger.kernel.org>; Wed,  4 May 2022 23:08:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 337A8B82AA2
        for <linux-sgx@vger.kernel.org>; Thu,  5 May 2022 06:08:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C851C385AC;
        Thu,  5 May 2022 06:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651730880;
        bh=6GVv0wbErdAXVNZq3mfDYypOlyu0BJ5NoUYoL8P8ty0=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=W8jPyy2LgiRlPBNwDd1DAYyNaMiJJVu3tuKy3+cka+q5OX+qXJFtCJ1JeILaS49SU
         eYp9Ba90jNMcc3NmOWHgjQV+FEOn1wE9FvKPoZsHBvku+LBtJbHC5i9cHHfIKFGFkU
         7bHCoRD+t9AQOm+vbhmGJ82c58pgWGcBnYqcvT+nKCQBLzZQijYhpiHC2dHjK/UOp0
         FDGckFtzXGiHusojU+fktAlreM8066UHO5KsYJ1oQ2NWYmqY+6MwxDuu6F71034eUq
         6ECqRTsZhuC43JpXtnewAFk91krn0AKmcVWkZx+ozhWh6kTDldCsbiILD0LAdX0rAn
         PGulNbWxqScVA==
Message-ID: <e023b1835cb961982d1b2dd75691edc17de5ed3d.camel@kernel.org>
Subject: Re: [RFC PATCH 0/4] SGX shmem backing store issue
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>,
        dave.hansen@linux.intel.com, linux-sgx@vger.kernel.org
Cc:     haitao.huang@intel.com
Date:   Thu, 05 May 2022 09:09:32 +0300
In-Reply-To: <cover.1651171455.git.reinette.chatre@intel.com>
References: <cover.1651171455.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.1 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thu, 2022-04-28 at 13:11 -0700, Reinette Chatre wrote:

> diff --git a/tools/testing/selftests/sgx/main.c b/tools/testing/selftests=
/sgx/main.c
> index d480c2dd2858..12008789325b 100644
> --- a/tools/testing/selftests/sgx/main.c
> +++ b/tools/testing/selftests/sgx/main.c
> @@ -398,7 +398,7 @@ TEST_F_TIMEOUT(enclave, unclobbered_vdso_oversubscrib=
ed_remove, 900)
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * Create enclave with ad=
ditional heap that is as big as all
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 * available physical SGX=
 memory.
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 */
> -=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0total_mem =3D get_total_epc_me=
m();
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0total_mem =3D get_total_epc_me=
m()/16;
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0ASSERT_NE(total_mem, 0);
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0TH_LOG("Creating an encla=
ve with %lu bytes heap may take a while ...",
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 total_mem);
>=20
> If the the test compiled with above snippet is renamed as "test_sgx_small=
"
> and the original renamed as "test_sgx_large" the two concurrent loops are
> run as follows:
>=20
> (for i in $(seq 1 999); do echo "Iteration $i"; sudo ./test_sgx_large; do=
ne ) > log.large 2>&1
> (for i in $(seq 1 9999); do echo "Iteration $i"; sudo ./test_sgx_small; d=
one ) > log.small 2>&1

Setting up VM image to see if I could reproduce this locally.

I'll reduce the iterations to 64 and 640 to scale the test to 256 MB EPC si=
ze.

BR, Jarkko
