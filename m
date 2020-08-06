Return-Path: <SRS0=kl42=BQ=vger.kernel.org=linux-sgx-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNPARSEABLE_RELAY autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A5C8C433DF
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Aug 2020 17:29:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9D77322DCC
	for <linux-sgx@archiver.kernel.org>; Thu,  6 Aug 2020 17:29:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="zSigtDix"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730147AbgHFR3C (ORCPT <rfc822;linux-sgx@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:29:02 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43768 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729852AbgHFRAh (ORCPT
        <rfc822;linux-sgx@vger.kernel.org>); Thu, 6 Aug 2020 13:00:37 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076GggDO190108;
        Thu, 6 Aug 2020 17:00:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : in-reply-to : references : date : message-id : mime-version :
 content-type; s=corp-2020-01-29;
 bh=8ETxh9POcmm1a7HCLuTWIWDrs1t/hR+hZh1eFjCnrR4=;
 b=zSigtDixPHeIE9/oIwmGYYnezU4SAVDltmr3xiXpKmlQ71WNPo5T8lDFDmtcch9lwdZN
 KH+oWKgaP0s70OYsoauDvKz3gAH8mN/ZZ8ePPSVS7OyLTjxGr7it2wFlNYclH0jtIn0c
 0kEsYL/VybMix5804qkumcOu3xU5FaBb7AVlOVu5F4h9RCnplhc0MoZvqEasMfiH1Nhf
 SijQ8Rdw1z5J1YuHFerwc95dQTBeGETMxnko76NfRff2PPhDkCzXhYPOcIcI5ozfPCPo
 BJlCbqX08+vBf6U2Zhg5J7mdh1xHV4D3ehpNtV4quLwYUnfasVfQ6r6ggrlD5I2lvQbH CA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 32r6fxm7at-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 06 Aug 2020 17:00:14 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 076GhqLD050483;
        Thu, 6 Aug 2020 17:00:13 GMT
Received: from userv0121.oracle.com (userv0121.oracle.com [156.151.31.72])
        by userp3030.oracle.com with ESMTP id 32r6cvs805-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 06 Aug 2020 17:00:11 +0000
Received: from abhmp0020.oracle.com (abhmp0020.oracle.com [141.146.116.26])
        by userv0121.oracle.com (8.14.4/8.13.8) with ESMTP id 076H07ee010325;
        Thu, 6 Aug 2020 17:00:07 GMT
Received: from starbug-mbp.localdomain (/79.97.215.145)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 06 Aug 2020 10:00:07 -0700
Received: by starbug-mbp.localdomain (Postfix, from userid 501)
        id 48426F0A107; Thu,  6 Aug 2020 18:00:02 +0100 (IST)
From:   Darren Kenny <darren.kenny@oracle.com>
To:     Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>, x86@kernel.org,
        linux-sgx@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        linux-security-module@vger.kernel.org,
        Jethro Beekman <jethro@fortanix.com>,
        Andy Lutomirski <luto@kernel.org>, akpm@linux-foundation.org,
        andriy.shevchenko@linux.intel.com, asapek@google.com, bp@alien8.de,
        cedric.xing@intel.com, chenalexchen@google.com,
        conradparker@google.com, cyhanish@google.com,
        dave.hansen@intel.com, haitao.huang@intel.com,
        josh@joshtriplett.org, kai.huang@intel.com, kai.svahn@intel.com,
        kmoy@google.com, ludloff@google.com, nhorman@redhat.com,
        npmccallum@redhat.com, puiterwijk@redhat.com, rientjes@google.com,
        sean.j.christopherson@intel.com, tglx@linutronix.de,
        yaozhangx@google.com
Subject: Re: [PATCH v36 15/24] x86/sgx: Allow a limited use of
 ATTRIBUTE.PROVISIONKEY for attestation
In-Reply-To: <20200716135303.276442-16-jarkko.sakkinen@linux.intel.com>
References: <20200716135303.276442-1-jarkko.sakkinen@linux.intel.com>
 <20200716135303.276442-16-jarkko.sakkinen@linux.intel.com>
Date:   Thu, 06 Aug 2020 18:00:02 +0100
Message-ID: <m27dubr9pp.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9705 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=1 mlxscore=0 bulkscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008060114
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9705 signatures=668679
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 impostorscore=0 adultscore=0
 bulkscore=0 priorityscore=1501 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 suspectscore=1 spamscore=0 clxscore=1015 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006250000
 definitions=main-2008060114
Sender: linux-sgx-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-sgx.vger.kernel.org>
X-Mailing-List: linux-sgx@vger.kernel.org

On Thursday, 2020-07-16 at 16:52:54 +03, Jarkko Sakkinen wrote:
> Provisioning Certification Enclave (PCE), the root of trust for other
> enclaves, generates a signing key from a fused key called Provisioning
> Certification Key. PCE can then use this key to certify an attestation key
> of a Quoting Enclave (QE), e.g. we get the chain of trust down to the
> hardware if the Intel signed PCE is used.
>
> To use the needed keys, ATTRIBUTE.PROVISIONKEY is required but should be
> only allowed for those who actually need it so that only the trusted
> parties can certify QE's.
>
> Obviously the attestation service should know the public key of the used
> PCE and that way detect illegit attestation, but whitelisting the legit
> users still adds an additional layer of defence.
>
> Add new device file called /dev/sgx/provision. The sole purpose of this
> file is to provide file descriptors that act as privilege tokens to allow
> to build enclaves with ATTRIBUTE.PROVISIONKEY set. A new ioctl called
> SGX_IOC_ENCLAVE_SET_ATTRIBUTE is used to assign this token to an enclave.
>
> Cc: linux-security-module@vger.kernel.org
> Acked-by: Jethro Beekman <jethro@fortanix.com>
> Suggested-by: Andy Lutomirski <luto@kernel.org>
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Reviewed-by: Darren Kenny <darren.kenny@oracle.com>

> ---
>  arch/x86/include/uapi/asm/sgx.h  | 11 ++++++++
>  arch/x86/kernel/cpu/sgx/driver.c | 18 ++++++++++++
>  arch/x86/kernel/cpu/sgx/driver.h |  2 ++
>  arch/x86/kernel/cpu/sgx/ioctl.c  | 47 ++++++++++++++++++++++++++++++++
>  4 files changed, 78 insertions(+)
>
> diff --git a/arch/x86/include/uapi/asm/sgx.h b/arch/x86/include/uapi/asm/sgx.h
> index 5edb08ab8fd0..57d0d30c79b3 100644
> --- a/arch/x86/include/uapi/asm/sgx.h
> +++ b/arch/x86/include/uapi/asm/sgx.h
> @@ -25,6 +25,8 @@ enum sgx_page_flags {
>  	_IOWR(SGX_MAGIC, 0x01, struct sgx_enclave_add_pages)
>  #define SGX_IOC_ENCLAVE_INIT \
>  	_IOW(SGX_MAGIC, 0x02, struct sgx_enclave_init)
> +#define SGX_IOC_ENCLAVE_SET_ATTRIBUTE \
> +	_IOW(SGX_MAGIC, 0x03, struct sgx_enclave_set_attribute)
>  
>  /**
>   * struct sgx_enclave_create - parameter structure for the
> @@ -63,4 +65,13 @@ struct sgx_enclave_init {
>  	__u64 sigstruct;
>  };
>  
> +/**
> + * struct sgx_enclave_set_attribute - parameter structure for the
> + *				      %SGX_IOC_ENCLAVE_SET_ATTRIBUTE ioctl
> + * @attribute_fd:	file handle of the attribute file in the securityfs
> + */
> +struct sgx_enclave_set_attribute {
> +	__u64 attribute_fd;
> +};
> +
>  #endif /* _UAPI_ASM_X86_SGX_H */
> diff --git a/arch/x86/kernel/cpu/sgx/driver.c b/arch/x86/kernel/cpu/sgx/driver.c
> index 5559bc18de41..b9af330a16fa 100644
> --- a/arch/x86/kernel/cpu/sgx/driver.c
> +++ b/arch/x86/kernel/cpu/sgx/driver.c
> @@ -138,6 +138,10 @@ static const struct file_operations sgx_encl_fops = {
>  	.get_unmapped_area	= sgx_get_unmapped_area,
>  };
>  
> +const struct file_operations sgx_provision_fops = {
> +	.owner			= THIS_MODULE,
> +};
> +
>  static struct miscdevice sgx_dev_enclave = {
>  	.minor = MISC_DYNAMIC_MINOR,
>  	.name = "enclave",
> @@ -145,6 +149,13 @@ static struct miscdevice sgx_dev_enclave = {
>  	.fops = &sgx_encl_fops,
>  };
>  
> +static struct miscdevice sgx_dev_provision = {
> +	.minor = MISC_DYNAMIC_MINOR,
> +	.name = "provision",
> +	.nodename = "sgx/provision",
> +	.fops = &sgx_provision_fops,
> +};
> +
>  int __init sgx_drv_init(void)
>  {
>  	unsigned int eax, ebx, ecx, edx;
> @@ -185,5 +196,12 @@ int __init sgx_drv_init(void)
>  		return ret;
>  	}
>  
> +	ret = misc_register(&sgx_dev_provision);
> +	if (ret) {
> +		pr_err("Creating /dev/sgx/provision failed with %d.\n", ret);
> +		misc_deregister(&sgx_dev_enclave);
> +		return ret;
> +	}
> +
>  	return 0;
>  }
> diff --git a/arch/x86/kernel/cpu/sgx/driver.h b/arch/x86/kernel/cpu/sgx/driver.h
> index e4063923115b..72747d01c046 100644
> --- a/arch/x86/kernel/cpu/sgx/driver.h
> +++ b/arch/x86/kernel/cpu/sgx/driver.h
> @@ -23,6 +23,8 @@ extern u64 sgx_attributes_reserved_mask;
>  extern u64 sgx_xfrm_reserved_mask;
>  extern u32 sgx_xsave_size_tbl[64];
>  
> +extern const struct file_operations sgx_provision_fops;
> +
>  long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg);
>  
>  int sgx_drv_init(void);
> diff --git a/arch/x86/kernel/cpu/sgx/ioctl.c b/arch/x86/kernel/cpu/sgx/ioctl.c
> index 3444de955191..95b0a1e62ea7 100644
> --- a/arch/x86/kernel/cpu/sgx/ioctl.c
> +++ b/arch/x86/kernel/cpu/sgx/ioctl.c
> @@ -669,6 +669,50 @@ static long sgx_ioc_enclave_init(struct sgx_encl *encl, void __user *arg)
>  	return ret;
>  }
>  
> +/**
> + * sgx_ioc_enclave_set_attribute - handler for %SGX_IOC_ENCLAVE_SET_ATTRIBUTE
> + * @filep:	open file to /dev/sgx
> + * @arg:	userspace pointer to a struct sgx_enclave_set_attribute instance
> + *
> + * Mark the enclave as being allowed to access a restricted attribute bit.
> + * The requested attribute is specified via the attribute_fd field in the
> + * provided struct sgx_enclave_set_attribute.  The attribute_fd must be a
> + * handle to an SGX attribute file, e.g. "/dev/sgx/provision".
> + *
> + * Failure to explicitly request access to a restricted attribute will cause
> + * sgx_ioc_enclave_init() to fail.  Currently, the only restricted attribute
> + * is access to the PROVISION_KEY.
> + *
> + * Note, access to the EINITTOKEN_KEY is disallowed entirely.
> + *
> + * Return: 0 on success, -errno otherwise
> + */
> +static long sgx_ioc_enclave_set_attribute(struct sgx_encl *encl,
> +					  void __user *arg)
> +{
> +	struct sgx_enclave_set_attribute params;
> +	struct file *attribute_file;
> +	int ret;
> +
> +	if (copy_from_user(&params, arg, sizeof(params)))
> +		return -EFAULT;
> +
> +	attribute_file = fget(params.attribute_fd);
> +	if (!attribute_file)
> +		return -EINVAL;
> +
> +	if (attribute_file->f_op != &sgx_provision_fops) {
> +		ret = -EINVAL;
> +		goto out;
> +	}
> +
> +	encl->allowed_attributes |= SGX_ATTR_PROVISIONKEY;
> +	ret = 0;
> +
> +out:
> +	fput(attribute_file);
> +	return ret;
> +}
>  
>  long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
>  {
> @@ -694,6 +738,9 @@ long sgx_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
>  	case SGX_IOC_ENCLAVE_INIT:
>  		ret = sgx_ioc_enclave_init(encl, (void __user *)arg);
>  		break;
> +	case SGX_IOC_ENCLAVE_SET_ATTRIBUTE:
> +		ret = sgx_ioc_enclave_set_attribute(encl, (void __user *)arg);
> +		break;
>  	default:
>  		ret = -ENOIOCTLCMD;
>  		break;
> -- 
> 2.25.1
